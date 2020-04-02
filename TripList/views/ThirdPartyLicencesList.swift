//
//  ThirdPartyLicencesList.swift
//  TripList
//
//  Created by Julien Vanheule on 02/04/2020.
//  Copyright © 2020 Julien Vanheule. All rights reserved.
//

import SwiftUI

struct ThirdPartyLicencesList: View {
    var body: some View {
        List {
            ForEach(thirdPartyMentions, id: \.title){ thirdParty in
                NavigationLink(destination: ThirdPartyLicenceView(thirdParty: thirdParty)){
                    Text(thirdParty.title)
                }
            }
        }
        .navigationBarTitle(Text("Mentions tierces"), displayMode: .inline)
    }
}

struct ThirdPartyLicencesList_Previews: PreviewProvider {
    static var previews: some View {
        ThirdPartyLicencesList()
    }
}

struct ThirdPartyLicenceView: View {
    var thirdParty: ThirdPartyMention
    
    var body: some View {
        ScrollView(.vertical){
            Text(thirdParty.licence).padding()
        }
        .navigationBarTitle(Text(thirdParty.title), displayMode: .inline)
    }
}
