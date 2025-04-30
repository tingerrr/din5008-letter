#import "@preview/letter-pro:3.0.0": letter-simple

#let self = sys.inputs.at("self", default: "self")
#let self = toml("/assets/" + self + ".toml")
#let recipient = (
  name: sys.inputs.at("name", default: none),
  street: sys.inputs.at("street", default: none),
  number: sys.inputs.at("number", default: none),
  zip: sys.inputs.at("zip", default: none),
  city: sys.inputs.at("city", default: none),
)

#for key in ("name", "street", "number", "zip", "city") {
  assert.ne(
    recipient.at(key), none,
    message: "Missing input `" + key + "` for recipient",
  )
}

#set text(lang: "de")

#show: letter-simple.with(
  sender: (
    name: self.name,
    address: self.address,
    extra: {
      if "mobile" in self [Telefon: #link("tel:" + self.mobile, self.mobile) \ ]
      if "email" in self [E-Mail: #link("mailto:" + self.email, self.email) \ ]
    },
  ),

  recipient: [
    #recipient.name \
    #recipient.street #recipient.number \
    #recipient.zip #recipient.city \
  ],
)
