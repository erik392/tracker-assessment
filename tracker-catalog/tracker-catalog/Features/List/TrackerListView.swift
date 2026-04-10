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
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.items, id: \.id) { item in
                    NavigationLink {
                        TrackerDetailView(
                            viewModel: TrackerDetailsViewModel(trackerId: item.id, apiClient: TrackerAPIClient())
                        )
                    } label: {
                        TrackerRowView(item: item)
                    }
                }
            }
            .navigationTitle("Trackers")
            .task {
                await viewModel.loadItems()
            }
        }
    }
}

struct TrackerRowView: View {
    let item: TrackerItem

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            // Header
            HStack {
                Text(item.name)
                    .font(.headline)

                Spacer()

                StatusBadge(status: item.status)
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
    let client = TrackerAPIClient(session: session)
    TrackerListView(viewModel: TrackerListViewModel(apiClient: client)).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
