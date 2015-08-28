/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page
    property string searchString
    property bool keepSearchFieldFocus: true

    Refresh {
        id: refreshLoad
        visible: false
    }

    onSearchStringChanged: {
        programmes.setFilterFixedString(searchString)
    }

    SilicaListView {
        id: listView
        model: programmes
        anchors.fill: parent
        currentIndex: -1 // otherwise currentItem will steal focus

        VerticalScrollDecorator {}

        header: Column {
            id: headerColumn
            width: page.width
            height: 200
            PageHeader {
                title: "BBC Programmes"
            }

            SearchField {
                id: searchField
                width: parent.width
                placeholderText: "Search programmes"
                inputMethodHints: Qt.ImhNoAutoUppercase

                Binding {
                    target: page
                    property: "searchString"
                    value: searchField.text.toLowerCase().trim()
                }
                onActiveFocusChanged: searchField.forceActiveFocus()
            }
        }

        PullDownMenu {
            MenuItem {
                text: qsTr("About")
            }
            MenuItem {
                text: qsTr("Refresh")
                onClicked: {
                    pageStack.push(refreshLoad)
                }
            }
        }

        ViewPlaceholder {
            enabled: listView.count === 0
            text: "No items found"
        }

        delegate: BackgroundItem {
            id: delegate

            /*
            ListView.onAdd: AddAnimation {
                target: delegate
            }
            ListView.onRemove: RemoveAnimation {
                id: animremove
                target: delegate
            }
            */


            Label {
                x: Theme.paddingLarge
                anchors.verticalCenter: parent.verticalCenter
                color: searchString.length > 0 ? (highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor)
                                               : (highlighted ? Theme.highlightColor : Theme.primaryColor)
                textFormat: Text.StyledText
                text: Theme.highlightText(name, searchString, Theme.highlightColor)
                clip: true
                width: parent.width - (2 * Theme.paddingLarge)
                elide: Text.ElideRight
            }
            onClicked: {
                console.log("Clicked " + name)
                pageStack.push(Qt.resolvedUrl("ProgInfo.qml"), { name: name, progId: progId })
            }
        }
    }
}


