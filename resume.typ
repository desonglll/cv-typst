#import "utils.typ"
#let info = yaml("infomation.yml")
#set page(
  // https://typst.app/docs/reference/layout/page
  paper: "a4",
  numbering: "1 / 1",
  number-align: center,
  margin: 1.25cm,
)

#show heading.where(level: 1): it => block(width: 100%)[
  #set text(size: 1.2em, font: "KaiTi", stroke: 0.01em)
  #it.body
  #v(2pt)
]

// Job titles
#let jobtitletext(info) = {
  if ("titles" in info.personal and info.personal.titles != none) {
    block(width: 100%)[
      #(
        info.personal.titles.join("  /  ")
      )
      #v(-4pt)
    ]
  } else { none }
}
// Address
#let addresstext(info) = {
  if ("location" in info.personal and info.personal.location != none) {
    // Filter out empty address fields
    let address = info.personal.location.pairs().filter(it => it.at(1) != none and str(it.at(1)) != "")
    // Join non-empty address fields with commas
    let location = address.map(it => str(it.at(1))).join(", ")

    block(width: 100%)[
      #location
      #v(-4pt)
    ]
  } else { none }
}

#let contacttext(info) = block(width: 100%)[
  #let profiles = (
    if "email" in info.personal and info.personal.email != none { box(link("mailto:" + info.personal.email)) },
    if ("phone" in info.personal and info.personal.phone != none) {
      box(link("tel:" + info.personal.phone))
    } else { none },
    if ("url" in info.personal) and (info.personal.url != none) {
      box(link(info.personal.url)[#info.personal.url.split("//").at(1)])
    },
  ).filter(it => it != none) // Filter out none elements from the profile array

  #if ("socials" in info.personal) and (info.personal.socials.len() > 0) {
    for profile in info.personal.socials {
      profiles.push(box(link(profile.url)[#profile.url.split("//").at(1)]))
    }
  }

  #set text(font: "Libertinus Serif", weight: "medium")
  #pad(x: 0em)[
    #profiles.join([#sym.space.en #sym.diamond.filled #sym.space.en])
  ]
]



#let cvheading(info) = {
  align(center)[
    = #info.personal.name
    #jobtitletext(info)
    #addresstext(info)
    #contacttext(info)
  ]
}


#let cvwork(info, title: "\u{efa6}\t工作经历", isbreakable: true) = {
  if "work" in info {
    heading(level: 2)[#title]
    if info.work.len() > 0 {
      for item in info.work {
        block(width: 100%, breakable: isbreakable)[
          #if ("url" in item) and (item.url != none) [
            === #link(item.url)[#text[#item.organization]] #h(1fr) #item.location \
          ] else [
            === #text[#item.organization] #h(1fr) #item.location \
          ]
        ]
        // Create a block layout for each work entry
        let index = 0
        if "positions" in item {
          for p in item.positions {
            if index != 0 { v(0.6em) }
            block(width: 100%, breakable: isbreakable, above: 0.6em)[
              // Parse ISO date strings into datetime objects
              #let start = utils.strpdate(p.startDate)
              #let end = utils.strpdate(p.endDate)
              // Line 2: Position and Date Range

              #if "highlights" in p {
                if "highlight" in p.highlights {
                  text(font: "KaiTi", stroke: 0.1pt)[#p.highlights.highlight]
                  h(1fr)
                }
              }
              #utils.daterange(start, end) \
              // Highlights or Description
              #if "highlights" in p {
                for hi in p.highlights [
                  - #eval(hi, mode: "markup")
                ]
              }
            ]
            index = index + 1
          }
        }
      }
    }
  }
}


#let cveducation(info, title: "\u{f4ca}\t教育背景", isbreakable: true) = {
  if ("education" in info) and (info.education != none) {
    block[
      == #title
      #for edu in info.education {
        let start = utils.strpdate(edu.startDate)
        let end = utils.strpdate(edu.endDate)

        let edu-items = ""
        if ("honors" in edu) and (edu.honors != none) {
          edu-items = edu-items + "- *任职荣誉*: " + edu.honors.join(", ") + "\n"
        }
        if ("courses" in edu) and (edu.courses != none) {
          edu-items = edu-items + "- *主修课程*: " + edu.courses.join(", ") + "\n"
        }
        if ("highlights" in edu) and (edu.highlights != none) {
          for hi in edu.highlights {
            edu-items = edu-items + "- " + hi + "\n"
          }
          edu-items = edu-items.trim("\n")
        }

        // Create a block layout for each education entry
        block(width: 100%, breakable: isbreakable)[
          // Line 1: Institution and Location
          #if ("url" in edu) and (edu.url != none) [
            === #link(edu.url)[#text[#edu.institution]] #h(1fr) #edu.location \
          ] else [
            === #edu.institution #h(1fr) #edu.location \
          ]
          // Line 2: Degree and Date
          #if ("area" in edu) and (edu.area != none) [
            #text(style: "italic")[#edu.studyType | #edu.area] #h(1fr)
          ] else [
            #text(style: "italic")[#edu.studyType] #h(1fr)
          ]
          #utils.daterange(start, end) \
          #eval(edu-items, mode: "markup")
        ]
      }
    ]
  }
}


#cvheading(info)
#cvwork(info)
#cveducation(info)
