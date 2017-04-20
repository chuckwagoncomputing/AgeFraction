import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.1
import QtQuick.Controls.Material 2.0
import Qt.labs.settings 1.0

ApplicationWindow {
 id: window

 visible: true
 title: "Age as Fraction"
 minimumWidth: 400
 minimumHeight: 400

 property var saved: []

 Settings {
  id: settings
  property string favorite: "09/15/1999"
  property string saved: ""
 }

 header: ToolBar {
  Material.foreground: "white"

  ToolButton {
   anchors.left: parent.left
   anchors.verticalCenter: parent.verticalCenter
   contentItem: Image {
    width: 30
    height: 30
    fillMode: Image.PreserveAspectFit
    horizontalAlignment: Image.AlignHCenter
    verticalAlignment: Image.AlignVCenter
    source: "images/list.png"
   }
   onClicked: {
    drawer.open()
   }
  }

  Label {
   anchors.horizontalCenter: parent.horizontalCenter
   anchors.verticalCenter: parent.verticalCenter
   id: titleLabel
   text: listView.currentItem ? listView.currentItem.text : "Age Fraction"
   font.pixelSize: 20
   horizontalAlignment: Qt.AlignHCenter
   verticalAlignment: Qt.AlignVCenter
   Layout.fillWidth: true
  }
 }

 Drawer {
  id: drawer
  width: Math.min(window.width, window.height) / 3 * 2
  height: window.height
  dragMargin: stackView.depth > 1 ? 0 : undefined

  ListView {
   id: listView
   currentIndex: -1
   anchors.fill: parent

   delegate: ItemDelegate {
    width: parent.width
    highlighted: ListView.isCurrentItem

    onClicked: {
     result.text = QmlBridge.updateFraction(model.title)
     drawer.close()
    }

    Text {
     anchors.verticalCenter: parent.verticalCenter
     anchors.left: parent.left
     anchors.leftMargin: 20
     text: model.title
    }
    Row {
     anchors.verticalCenter: parent.verticalCenter
     anchors.right: parent.right
     Image {
      width: 30
      height: 30
      anchors.verticalCenter: parent.verticalCenter
      anchors.right: favbutton.left
      anchors.rightMargin: 15
      fillMode: Image.PreserveAspectFit
      source: "images/trash.png"
      MouseArea {
       anchors.fill: parent
       onClicked: {
        window.saved.splice(model.index, 1)
        listView.model.remove(model.index)
        settings.saved = window.saved.join(",")
       }
      }
     }
     Image {
      id: favbutton
      width: 30
      height: 30
      anchors.verticalCenter: parent.verticalCenter
      anchors.right: parent.right
      anchors.rightMargin: 15
      fillMode: Image.PreserveAspectFit
      source: settings.favorite == model.title ? "images/heart.png" : "images/heart_border.png"
      MouseArea {
       anchors.fill: parent
       onClicked: {
        settings.favorite = model.title
       }
      }
     }
    }
   }

   model: ListModel {
    Component.onCompleted: {
     window.saved = settings.saved.split(",")
     for (var i = 0; i < window.saved.length; i++) {
      append({title: window.saved[i]})
     }
    }
   }

   ScrollIndicator.vertical: ScrollIndicator { }

   ToolBar {
    width: parent.width
    anchors.bottom: parent.bottom
    Text {
     anchors.right: parent.right
     anchors.rightMargin: 15
     anchors.verticalCenter: parent.verticalCenter
     text: "+"
     font.pixelSize: 30
     MouseArea {
      anchors.fill: parent
      onClicked: {
       newdate.contentItem.text = ""
       newdate.open()
      }
     }
    }
   }
  }
 }

 Dialog {
  id: newdate
  contentWidth: window.width / 2
  contentHeight: window.height / 4
  standardButtons: Dialog.Cancel | Dialog.Ok

  contentItem: TextField {
   id: newtext
   text: ""
   placeholderText: "mm/dd/yyyy"
  }

  onAccepted: {
   window.saved.push(newtext.text)
   listView.model.append({title: newtext.text})
   settings.saved = window.saved.join(",")
  }
 }

 StackView {
  id: stackView
  anchors.fill: parent

  initialItem: Pane {
   id: pane
   Text {
    id: result
    anchors.verticalCenter: parent.verticalCenter
    anchors.horizontalCenter: parent.horizontalCenter
    font.pixelSize: 30
    text: settings.favorite.length == 10 ? QmlBridge.updateFraction(settings.favorite) : "Select a date from the menu."
   }
  }
 }
}
