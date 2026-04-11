//
//  TrackerDetailsView.swift
//  tracker-catalog
//
//  Created by Erik Egers on 2026/04/10.
//

import SwiftUI

struct TrackerDetailsView: View {
    @StateObject var viewModel: TrackerDetailsViewModel
    @EnvironmentObject var favourites: FavouritesStore
    
    var body: some View {
        Group {
            switch viewModel.state {
                
            case .loading:
                ProgressView()
                
            case .failed:
                VStack(spacing: 12) {
                    Text("Failed to load details")
                    
                    Button("Retry") {
                        Task {
                            await viewModel.loadDetails()
                        }
                    }
                }
                
            case .loaded(let item):
                content(item)
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadDetails()
        }
    }
    
    @ViewBuilder
    private func content(_ item: DetailsResponse) -> some View {
        TrackerDetailHeaderView(
            item: item,
            isFavourite: favourites.isFavourite(item.id),
            onFavouriteToggle: {
                favourites.toggle(item.id)
            }
        )
    }
}

struct TrackerDetailHeaderView: View {
    let item: DetailsResponse
    let isFavourite: Bool
    let onFavouriteToggle: () -> Void
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                // MARK: Header
                HStack {
                    Text(item.name)
                        .font(.largeTitle.bold())
                    
                    Spacer()
                    
                    StatusBadge(status: item.status)
                    
                    Button {
                        onFavouriteToggle()
                    } label: {
                        Image(systemName: isFavourite ? "star.fill" : "star")
                            .foregroundStyle(.red)
                    }
                    .buttonStyle(.borderless)
                }
                
                Text(item.category)
                    .font(.headline)
                    .foregroundStyle(.secondary)
                
                Divider()
                
                // MARK: Summary
                Text(item.summary)
                    .font(.body)
                
                // MARK: Full Details
                VStack(alignment: .leading, spacing: 8) {
                    Text("Details")
                        .font(.headline)
                    
                    Text(item.details)
                        .font(.body)
                }
                
                Divider()
                
                // MARK: Tags
                VStack(alignment: .leading, spacing: 8) {
                    Text("Tags")
                        .font(.headline)
                    
                    FlowLayout(tags: item.tags)
                }
                
                Divider()
                
                // MARK: Specs
                VStack(alignment: .leading, spacing: 12) {
                    Text("Specifications")
                        .font(.headline)
                    
                    SpecRow(title: "Battery", value: item.specs.battery)
                    
                    SpecRow(
                        title: "Connectivity",
                        value: item.specs.connectivity.joined(separator: ", ")
                    )
                    
                    SpecRow(title: "Dimensions", value: item.specs.dimensions)
                }
                
                Divider()
                
                // MARK: Footer
                Text("Last updated: \(item.lastUpdated.formatted(date: .abbreviated, time: .shortened))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
    }
}

struct SpecRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack(alignment: .top) {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(width: 120, alignment: .leading)
            
            Text(value)
                .font(.subheadline)
            
            Spacer()
        }
    }
}

struct FlowLayout: View {
    let tags: [String]
    
    var body: some View {
        LazyVGrid(
            columns: [
                GridItem(.adaptive(minimum: 80), spacing: 8)
            ],
            alignment: .leading,
            spacing: 8
        ) {
            ForEach(tags, id: \.self) { tag in
                Text("#\(tag)")
                    .font(.caption)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.gray.opacity(0.15))
                    .clipShape(Capsule())
            }
        }
    }
}

#Preview {
    let session = try! MockSessionFactory.makeMockSession()
    let client = MockTrackerAPIClient(session: session)
    TrackerDetailsView(viewModel: TrackerDetailsViewModel(trackerId: "trk-1001", apiClient: client))
        .environmentObject(FavouritesStore())
}
