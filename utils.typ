// Helper Functions
#let monthname(n, display: "short") = {
  n = int(n)
  let month = ""

  if n == 1 { month = "一月" } else if n == 3 { month = "三月" } else if n == 2 { month = "二月" } else if (
    n == 4
  ) { month = "四月" } else if n == 5 { month = "五月" } else if n == 6 { month = "六月" } else if n == 7 {
    month = "七月"
  } else if n == 8 { month = "八月" } else if n == 9 { month = "九月" } else if n == 10 {
    month = "十月"
  } else if n == 11 { month = "十一月" } else if n == 12 { month = "十二月" } else { month = none }
  if month != none {
    if display == "short" {
      month = month
    } else {
      month
    }
  }
  month
}

#let strpdate(isodate) = {
  let date = ""
  if lower(isodate) != "present" {
    let year = int(isodate.slice(0, 4))
    let month = int(isodate.slice(5, 7))
    let day = int(isodate.slice(8, 10))
    let monthName = monthname(month, display: "short")
    date = datetime(year: year, month: month, day: day)
    date = date.display("[year repr:full]") + "年" + " " + monthName
  } else if lower(isodate) == "present" {
    date = "至今"
  }
  return date
}

#let daterange(start, end) = {
  if start != none and end != none [
    #start #sym.dash.en #end
  ]
  if start == none and end != none [
    #end
  ]
  if start != none and end == none [
    #start
  ]
}
