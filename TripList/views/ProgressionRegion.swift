//
//  ProgressionRegion.swift
//  TripList
//
//  Created by Julien Vanheule on 08/02/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI
import QGrid

struct ProgressionRegion: View {
    var region: PlaceRegion
    @EnvironmentObject var session: Session
    
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                RegionContent(cells: self.getPlaces(), width: geometry.size.width)
            }
        }
        .navigationBarTitle(Text(region.name))
    }
    
    private func getPlaces() -> [ProgressionCell]{
        let places = PlaceStore.shared.getAllForRegion(regionId: self.region.id).sorted { (p1, p2) -> Bool in
            p1.category.rawValue < p2.category.rawValue
        }
        
        var result: [ProgressionCell] = []
        var premiumCount = 0
        
        places.forEach { (place) in
            if place.iap && !session.isPremium {
                premiumCount += 1
            } else {
                result.append(ProgressionCell(place: place))
            }
        }
        
        if premiumCount > 0 {
            result.append(ProgressionCell(premiumWithMissing: premiumCount))
        }
        
        
        return result
    }
}

struct ProgressionCell: Identifiable {
    
    
    enum ProgressionCellType {
        case placeCell
        case premiumCell
    }
    
    var id: String
    var type: ProgressionCellType
    var place: Place!
    var missingPlacesCount: Int!
    
    init(premiumWithMissing: Int){
        id = "premium"
        type = .premiumCell
        missingPlacesCount = premiumWithMissing
    }
    
    init(place: Place){
        id = place.id
        type = .placeCell
        self.place = place
    }
}

struct ProgressionRegion_Previews: PreviewProvider {
    static var previews: some View {
        ProgressionRegion(region: regionsData[0]).environmentObject(Session())
    }
}

struct ProgressionItem: View {
    var cell: ProgressionCell
    var size: CGFloat
    
    @State private var isPurchasePresented: Bool = false
    
    var fetchRequest: FetchRequest<Completion>
    var completions: FetchedResults<Completion> { fetchRequest.wrappedValue }
    @EnvironmentObject var session: Session
    
    init(cell: ProgressionCell, size: CGFloat) {
        self.cell = cell
        self.size = size
        
        var placeId = "premium"
        if let place = cell.place {
            placeId = place.id
        }
        
        fetchRequest = FetchRequest<Completion>(entity: Completion.entity(), sortDescriptors: [], predicate: NSPredicate(format: "placeId == %@", placeId))
    }
    
    var body: some View {
        VStack {
            if cell.type == .placeCell {
                NavigationLink(
                    destination: PlaceDetail(place: cell.place!, displayAssociates: false)
                    //destination: LazyView(PlacePager(places: PlaceStore.shared.getAllForRegion(regionId: self.cell.place!.regionId), initialePlace: self.cell.place!))
                ) {
                    if self.completions.first != nil {
                        ImageStore.shared.image(forPlace: self.cell.place!)
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: self.size, height: self.size).clipped()
                        .cornerRadius(10).frame(width: self.size, height: self.size)
                    } else {
                        Image("mapicon.\(cell.place!.category)")
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .padding(8)
                        .frame(width: self.size, height: self.size)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(Color(AppStyle.color(for: cell.place.category)), lineWidth: 4)
                        )
                        .background(Color(UIColor(hex: 0xDDDDDD)))
                        .cornerRadius(10)
                    }
                }
            } else {
                Button(action: {self.isPurchasePresented.toggle()}) {
                    VStack {
                        Image(systemName: "star.fill").font(.title)
                        Text("+ \(cell.missingPlacesCount!)")
                    }
                    .foregroundColor(.yellow)
                    .padding(8)
                    .frame(width: self.size, height: self.size)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(Color.yellow, lineWidth: 4)
                    )
                        .background(Color.black)
                    .cornerRadius(10)
                }
                .sheet(isPresented: self.$isPurchasePresented, onDismiss: {
                    print("Dismiss")
                }, content: {
                    PurchasePage().environmentObject(self.session)
                })
                
            }
        }
    }
}



struct RegionContent: View {
    var cells: [ProgressionCell]
    var cellSize: CGFloat
    let cols = UIDevice.current.userInterfaceIdiom == .phone ? 5 : 10
    let rows: Int
    
    let VPADDING: CGFloat = 10.0
    let HSPACING: CGFloat = 10
    
    init(cells: [ProgressionCell], width: CGFloat){
        self.cellSize = (width/CGFloat(self.cols))-10
        self.cells = cells
        self.rows = Int(ceil(CGFloat(cells.count)/CGFloat((cols))))
    }
    
    var body: some View {
        QGrid(cells,
              columns: cols,
              columnsInLandscape: cols,
              vSpacing: 10,
              hSpacing: HSPACING,
              vPadding: VPADDING,
              hPadding: 10) { cell in
                ProgressionItem(cell: cell, size: self.cellSize)
        }.frame(height: VPADDING+(self.cellSize+HSPACING)*CGFloat(self.rows)+VPADDING)
    }
}
