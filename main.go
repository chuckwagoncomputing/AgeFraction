package main

import (
 "time"
 "fmt"
 "os"
 "github.com/therecipe/qt/core"
 "github.com/therecipe/qt/gui"
 "github.com/therecipe/qt/qml"
 "github.com/therecipe/qt/quickcontrols2"
)

type QmlBridge struct {
 core.QObject

 _ func(data string) string `slot:"updateFraction"`
}

func isin(one int, two int, three int, four int, five int, six int) bool {
 if isle(one, two, three, four) && islt(three, four, five, six) {
  return true
 } else {
  return false
 }
}

func islt(one int, two int, three int, four int) bool {
 if (one * four) < (two * three) {
  return true
 } else {
  return false
 }
}

func isle(one int, two int, three int, four int) bool {
 if (one * four) <= (two * three) {
  return true
 } else {
  return false
 }
}

func getFraction(birth time.Time) string {
 today := time.Now()
 daystoday := today.YearDay()
 daysatbirth := birth.YearDay()
 yearsold := today.Year() - birth.Year()
 dayssince := 0
 if daysatbirth > daystoday {
  yearsold = yearsold - 1
  dayssince = (365 - daysatbirth) + daystoday
 } else {
  dayssince = daystoday - daysatbirth
 }

 if dayssince == 0 {
  return fmt.Sprintf("%d years old.", yearsold)
 }

 lown := 0
 lowd := 1
 highn := 1
 highd := 0

 for 1 == 1 {
  num := lown + highn
  den := lowd + highd
  if isin(dayssince, 365, num, den, (dayssince + 1), 365) {
   return fmt.Sprintf("%d %d/%d", yearsold, num, den)
  } else if islt(num, den, dayssince, 365) {
   lown = num
   lowd = den
  } else if isle((dayssince + 1), 365, num, den) {
   highn = num
   highd = den
  }
 }
 return "Error"
}

func main() {
 //enable high dpi scaling
 core.QCoreApplication_SetAttribute(core.Qt__AA_EnableHighDpiScaling, true)
 gui.NewQGuiApplication(len(os.Args), os.Args)

 //use the material style for qml controls
 //"universal" is also available
 quickcontrols2.QQuickStyle_SetStyle("material")

 //create a qml application
 view := qml.NewQQmlApplicationEngine(nil)

 var qmlBridge = NewQmlBridge(nil)
 qmlBridge.ConnectUpdateFraction(func(data string) string {
  date, err := time.Parse("01/02/2006", data)
  if err != nil {
   return "Error"
  } else {
   return getFraction(date)
  }
  return "Error"
 })

 view.RootContext().SetContextProperty("QmlBridge", qmlBridge)

 //load the main qml file
 view.Load(core.NewQUrl3("qrc:///qml/main.qml", 0))
 //enter the main event loop
 gui.QGuiApplication_Exec()
}
