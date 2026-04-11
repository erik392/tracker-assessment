//
//  TrackerListView.swift
//  tracker-catalog
//
//  Created by Erik Egers on 2026/04/08.
//

import SwiftUI
import CoreData

struct TrackerListView: View {
    @StateObject var viewModel: TrackerListViewModel
    @EnvironmentObject var favourites: FavouritesStore

    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.state {

                case .loading:
                    ProgressView()

                case .failed:
                    VStack(spacing: 12) {
                        Text("Failed to load items")

                        Button("Retry") {
                            Task {
                                await viewModel.loadItems()
                            }
                        }
                    }

                case .loaded:
                    content(viewModel.filteredItems)
                        .refreshable {
                            await viewModel.loadItems()
                        }
                }
            }
            .navigationTitle("Trackers")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $viewModel.searchText)
            .navigationDestination(for: String.self) { id in
                let session = try! MockSessionFactory.makeMockSession()
                let client = MockTrackerAPIClient(session: session)
                TrackerDetailsView(viewModel: TrackerDetailsViewModel(trackerId: id, apiClient: client))
            }
            .task {
                await viewModel.loadItems()
            }
        }
    }
    
    @ViewBuilder
    private func content(_ items: [TrackerItem]) -> some View {
        List {
            ForEach(items, id: \.id) { item in
                NavigationLink(value: item.id) {
                    TrackerRowView(
                        item: item,
                        isFavourite: favourites.isFavourite(item.id),
                        onFavouriteToggle: {
                            favourites.toggle(item.id)
                        }
                    )
                }
            }
        }
    }
}

struct TrackerRowView: View {
    let item: TrackerItem
    let isFavourite: Bool
    let onFavouriteToggle: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            // Header
            HStack {
                Text(item.name)
                    .font(.headline)

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

            // Category
            Text(item.category)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            // Summary
            Text(item.summary)
                .font(.body)
                .lineLimit(2)
                .foregroundStyle(.primary)

            // Tags
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(item.tags, id: \.self) { tag in
                        Text("#\(tag)")
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.gray.opacity(0.15))
                            .clipShape(Capsule())
                    }
                }
            }
            
            // Footer
            Text("Updated: \(item.lastUpdated.formatted(date: .abbreviated, time: .shortened))")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 6)
    }
}

struct StatusBadge: View {
    let status: String

    var color: Color {
        switch status.lowercased() {
        case "active": return .green
        case "inactive": return .red
        default: return .orange
        }
    }

    var body: some View {
        Text(status.capitalized)
            .font(.caption2)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.15))
            .foregroundStyle(color)
            .clipShape(Capsule())
    }
}

#Preview {
    let session = try! MockSessionFactory.makeMockSession()
    let client = MockTrackerAPIClient(session: session)
    TrackerListView(viewModel: TrackerListViewModel(apiClient: client))
        .environmentObject(FavouritesStore())
}
