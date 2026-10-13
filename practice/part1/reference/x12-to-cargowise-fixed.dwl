%dw 2.0
output application/xml
import * from dw::core::Strings
import * from dw::core::Periods
// Corrected copy of x12-to-cargowise.dwl. Each change is marked "FIX n" and explained in
// notes/part1-super-detailed.md, section 11.6. Element names are kept identical to the
// original so the target (your mock CargoWise API) sees the same XML layout.

// FIX 1: one short alias instead of repeating the full path ~30 times
var booking = payload.Booking.TransactionSets.v004010."300"[0]
var heading = booking.Heading
var detail  = booking.Detail
var ports   = heading."130_R4_Loop"."130_R4" default []
var packs   = detail."010_LX_Loop"."040_L0" default []
fun port(code) = (ports filter ((p) -> p.R401 == code))[0]
fun stamp(d) = d as String { format: "yyyy-MM-dd'T'HH:mm:ss" }

// FIX 2: explicit conversions instead of relying on auto-coercion
var BookingNum = (substringAfter(heading."020_B1".B102, "SHIP") as Number) * 8989
var Addresses = {
    "CN": "ConsigneeAddress",
    "FW": "SendingForwarderAddress",
    "SH": "LocalClientAddress"
}
var CountryCodeLists = {
  "BD": "Bangladesh",
  "BE": "Belgium",
  "BF": "Burkina Faso",
  "BG": "Bulgaria",
  "BA": "Bosnia and Herzegovina",
  "BB": "Barbados",
  "WF": "Wallis and Futuna",
  "BL": "Saint Barthelemy",
  "BM": "Bermuda",
  "BN": "Brunei",
  "BO": "Bolivia",
  "BH": "Bahrain",
  "BI": "Burundi",
  "BJ": "Benin",
  "BT": "Bhutan",
  "JM": "Jamaica",
  "BV": "Bouvet Island",
  "BW": "Botswana",
  "WS": "Samoa",
  "BQ": "Bonaire, Saint Eustatius and Saba ",
  "BR": "Brazil",
  "BS": "Bahamas",
  "JE": "Jersey",
  "BY": "Belarus",
  "BZ": "Belize",
  "RU": "Russia",
  "RW": "Rwanda",
  "RS": "Serbia",
  "TL": "East Timor",
  "RE": "Reunion",
  "TM": "Turkmenistan",
  "TJ": "Tajikistan",
  "RO": "Romania",
  "TK": "Tokelau",
  "GW": "Guinea-Bissau",
  "GU": "Guam",
  "GT": "Guatemala",
  "GS": "South Georgia and the South Sandwich Islands",
  "GR": "Greece",
  "GQ": "Equatorial Guinea",
  "GP": "Guadeloupe",
  "JP": "Japan",
  "GY": "Guyana",
  "GG": "Guernsey",
  "GF": "French Guiana",
  "GE": "Georgia",
  "GD": "Grenada",
  "GB": "United Kingdom",
  "GA": "Gabon",
  "SV": "El Salvador",
  "GN": "Guinea",
  "GM": "Gambia",
  "GL": "Greenland",
  "GI": "Gibraltar",
  "GH": "Ghana",
  "OM": "Oman",
  "TN": "Tunisia",
  "JO": "Jordan",
  "HR": "Croatia",
  "HT": "Haiti",
  "HU": "Hungary",
  "HK": "Hong Kong",
  "HN": "Honduras",
  "HM": "Heard Island and McDonald Islands",
  "VE": "Venezuela",
  "PR": "Puerto Rico",
  "PS": "Palestinian Territory",
  "PW": "Palau",
  "PT": "Portugal",
  "SJ": "Svalbard and Jan Mayen",
  "PY": "Paraguay",
  "IQ": "Iraq",
  "PA": "Panama",
  "PF": "French Polynesia",
  "PG": "Papua New Guinea",
  "PE": "Peru",
  "PK": "Pakistan",
  "PH": "Philippines",
  "PN": "Pitcairn",
  "PL": "Poland",
  "PM": "Saint Pierre and Miquelon",
  "ZM": "Zambia",
  "EH": "Western Sahara",
  "EE": "Estonia",
  "EG": "Egypt",
  "ZA": "South Africa",
  "EC": "Ecuador",
  "IT": "Italy",
  "VN": "Vietnam",
  "SB": "Solomon Islands",
  "ET": "Ethiopia",
  "SO": "Somalia",
  "ZW": "Zimbabwe",
  "SA": "Saudi Arabia",
  "ES": "Spain",
  "ER": "Eritrea",
  "ME": "Montenegro",
  "MD": "Moldova",
  "MG": "Madagascar",
  "MF": "Saint Martin",
  "MA": "Morocco",
  "MC": "Monaco",
  "UZ": "Uzbekistan",
  "MM": "Myanmar",
  "ML": "Mali",
  "MO": "Macao",
  "MN": "Mongolia",
  "MH": "Marshall Islands",
  "MK": "Macedonia",
  "MU": "Mauritius",
  "MT": "Malta",
  "MW": "Malawi",
  "MV": "Maldives",
  "MQ": "Martinique",
  "MP": "Northern Mariana Islands",
  "MS": "Montserrat",
  "MR": "Mauritania",
  "IM": "Isle of Man",
  "UG": "Uganda",
  "TZ": "Tanzania",
  "MY": "Malaysia",
  "MX": "Mexico",
  "IL": "Israel",
  "FR": "France",
  "IO": "British Indian Ocean Territory",
  "SH": "Saint Helena",
  "FI": "Finland",
  "FJ": "Fiji",
  "FK": "Falkland Islands",
  "FM": "Micronesia",
  "FO": "Faroe Islands",
  "NI": "Nicaragua",
  "NL": "Netherlands",
  "NO": "Norway",
  "NA": "Namibia",
  "VU": "Vanuatu",
  "NC": "New Caledonia",
  "NE": "Niger",
  "NF": "Norfolk Island",
  "NG": "Nigeria",
  "NZ": "New Zealand",
  "NP": "Nepal",
  "NR": "Nauru",
  "NU": "Niue",
  "CK": "Cook Islands",
  "XK": "Kosovo",
  "CI": "Ivory Coast",
  "CH": "Switzerland",
  "CO": "Colombia",
  "CN": "China",
  "CM": "Cameroon",
  "CL": "Chile",
  "CC": "Cocos Islands",
  "CA": "Canada",
  "CG": "Republic of the Congo",
  "CF": "Central African Republic",
  "CD": "Democratic Republic of the Congo",
  "CZ": "Czech Republic",
  "CY": "Cyprus",
  "CX": "Christmas Island",
  "CR": "Costa Rica",
  "CW": "Curacao",
  "CV": "Cape Verde",
  "CU": "Cuba",
  "SZ": "Swaziland",
  "SY": "Syria",
  "SX": "Sint Maarten",
  "KG": "Kyrgyzstan",
  "KE": "Kenya",
  "SS": "South Sudan",
  "SR": "Suriname",
  "KI": "Kiribati",
  "KH": "Cambodia",
  "KN": "Saint Kitts and Nevis",
  "KM": "Comoros",
  "ST": "Sao Tome and Principe",
  "SK": "Slovakia",
  "KR": "South Korea",
  "SI": "Slovenia",
  "KP": "North Korea",
  "KW": "Kuwait",
  "SN": "Senegal",
  "SM": "San Marino",
  "SL": "Sierra Leone",
  "SC": "Seychelles",
  "KZ": "Kazakhstan",
  "KY": "Cayman Islands",
  "SG": "Singapore",
  "SE": "Sweden",
  "SD": "Sudan",
  "DO": "Dominican Republic",
  "DM": "Dominica",
  "DJ": "Djibouti",
  "DK": "Denmark",
  "VG": "British Virgin Islands",
  "DE": "Germany",
  "YE": "Yemen",
  "DZ": "Algeria",
  "US": "United States",
  "UY": "Uruguay",
  "YT": "Mayotte",
  "UM": "United States Minor Outlying Islands",
  "LB": "Lebanon",
  "LC": "Saint Lucia",
  "LA": "Laos",
  "TV": "Tuvalu",
  "TW": "Taiwan",
  "TT": "Trinidad and Tobago",
  "TR": "Turkey",
  "LK": "Sri Lanka",
  "LI": "Liechtenstein",
  "LV": "Latvia",
  "TO": "Tonga",
  "LT": "Lithuania",
  "LU": "Luxembourg",
  "LR": "Liberia",
  "LS": "Lesotho",
  "TH": "Thailand",
  "TF": "French Southern Territories",
  "TG": "Togo",
  "TD": "Chad",
  "TC": "Turks and Caicos Islands",
  "LY": "Libya",
  "VA": "Vatican",
  "VC": "Saint Vincent and the Grenadines",
  "AE": "United Arab Emirates",
  "AD": "Andorra",
  "AG": "Antigua and Barbuda",
  "AF": "Afghanistan",
  "AI": "Anguilla",
  "VI": "U.S. Virgin Islands",
  "IS": "Iceland",
  "IR": "Iran",
  "AM": "Armenia",
  "AL": "Albania",
  "AO": "Angola",
  "AQ": "Antarctica",
  "AS": "American Samoa",
  "AR": "Argentina",
  "AU": "Australia",
  "AT": "Austria",
  "AW": "Aruba",
  "IN": "India",
  "AX": "Aland Islands",
  "AZ": "Azerbaijan",
  "IE": "Ireland",
  "ID": "Indonesia",
  "UA": "Ukraine",
  "QA": "Qatar",
  "MZ": "Mozambique"
}
// FIX 3: R401 codes — L = port of loading, D = port of discharge, E = place of delivery,
// R = place of receipt. The original read "E" for discharge and "D" for delivery.
var PortofDischarge = port("D")
var portofloading   = port("L")
var PortOfDelivery  = port("E")
var PortOfOrigin    = port("R")
---
{
    UniversalShipment: {
        Shipment: {
            DataSourceCollection: {
                DataSource: [
                    {
                        Type: "BookingConformation",
                        Value: "SOO" ++ (BookingNum as String)
                    }
                ]
            },
            // FIX 4: readable timestamps (the original printed nanoseconds and a zone)
            BookDate: stamp(now() + |PT6H|),
            CompanyCode: heading."020_B1".B101,
            OrganizationAddressCollection: {
                OrgAddress: heading."080_N1_Loop" map ((item, index) -> {
                    AddressType: Addresses[item."080_N1".N101] default item."080_N1".N101,
                    Address: item."100_N3"[0].N301,
                    // FIX 5: <City> appeared twice in every address; now once
                    City: item."110_N4".N401,
                    CompanyName: item."080_N1".N102,
                    Country: {
                        Code: item."110_N4".N404,
                        Name: CountryCodeLists[item."110_N4".N404]
                    },
                    StateCode: item."110_N4".N402,
                    PostalCode: item."110_N4".N403,
                    ContactName: item."120_G61"[0].G6102,
                    Mail: item."120_G61"[0].G6104
                })
            },
            TransportMode: "SEA",
            ActualChargableAmount: (substring(heading."020_B1".B102, 8, 10) as Number) * 40,
            BookiongConformationReference: "",
            Branch: { Code: "047", Name: "Bngalore(main)" },
            ContainerMode: { Code: "LSE", Description: "Loose" },
            EntryStatus: { Code: "OCC", Description: "Cleared all stages" },
            GoodsDescription: "Dont accepts if seals are broken or open",
            GoodsVlaueCurrency: { Code: "INR", Description: "Indian Rupees" },
            InsuranceValue: 0.000,
            MessageType: { Code: "EXP", Description: "Export Service" },
            PaymentMethod: { Code: "PP", Description: "Prepaid" },
            PortofDischarge: { Code: PortofDischarge.R403, Name: PortofDischarge.R404 },
            PortOfLoading:   { Code: portofloading.R403,   Name: portofloading.R404 },
            PortOfDelivery:  { Code: PortOfDelivery.R403,  Name: PortOfDelivery.R404 },
            PortOfOrigin:    { Code: PortOfOrigin.R403,    Name: PortOfOrigin.R404 },
            ServiceLevel: { Code: "STD", Description: "Standard House Shifting" },
            TotalNoOfPacks: sum(packs.L008),
            TotalVolume: sum(packs.L006),
            TotalVolumeunits: {
                Code: if (packs[0].L007 == "X") "M3" else "C3",
                Descripton: if (packs[0].L007 == "X") "Cubicmeters" else "Cubicfeet"
            },
            TotalWeight: sum(packs.L004),
            TotalWeightUnits: {
                Code: if (packs[0].L011 == "K") "KG" else "LB",
                Descripton: if (packs[0].L011 == "K") "Kilograms" else "Pounds"
            },
            // FIX 6: the vessel name arrives as " COSCO" (leading space)
            VesselName: trim(detail."090_V1"[0].V102),
            VoyageHeightNo: 87979,
            WaybillNumber: "123e4567-e89b-12d3-a487-4366908653338",
            WaybillType: { Code: "MWB", Description: "Master Way Bill Number" },
            LocalProcessing: {
                DeliveryDate: stamp(now() + days(2)),
                PickUpDate: heading."020_B1".B103,
                OrderCollection: {
                    OrderNumber: (heading."069_N9" default []) map ((item, index) -> {
                        OrderReference: item.N902,
                        Sequence: index + 1,
                        ReferenceType: item.N901
                    })
                }
            },
            ContainerCollection: {
                Container: [
                    {
                        Type: "40GP",
                        Description: "40ft General Purpose",
                        ContainerNumber: "MIEU" ++ substring(heading."069_N9"[0].N902, 6, 10)
                    }
                ]
            },
            DateCollection: {
                Date: [
                    { Type: "EstomatedDelivery", Value: stamp(now() + |P2D|) },
                    { Type: "EstomatedPickup",   Value: heading."020_B1".B103 }
                ]
            },
            PackingLineCollection: {
                PackingLine: detail."010_LX_Loop" map ((item, index) -> {
                    Commodity: { Code: "G", Description: "General Cargo" },
                    ContainerNumber: "MIEU" ++ substring(heading."069_N9"[0].N902, 6, 10),
                    GoodsDescription: detail."110_K1"[0].K102,
                    PackQty: item."040_L0".L008,
                    PackType: { Code: item."040_L0".L009, Description: "Packages" },
                    Weight: item."040_L0".L004,
                    // FIX 7: every match gets an else branch, so an unexpected code
                    // doesn't fail the whole transform
                    WeightUnit: {
                        Code: item."040_L0".L011 match {
                            case "K" -> "KG"
                            case "L" -> "LB"
                            else -> item."040_L0".L011
                        },
                        Description: item."040_L0".L011 match {
                            case "K" -> "Kilograms"
                            case "L" -> "Pounds"
                            else -> "Unknown"
                        }
                    },
                    Volume: item."040_L0".L006,
                    // FIX 8: this block was a second <WeightUnit>; it holds volume units
                    VolumeUnit: {
                        Code: item."040_L0".L007 match {
                            case "X" -> "M3"
                            case "C" -> "C3"
                            else -> item."040_L0".L007
                        },
                        Description: item."040_L0".L007 match {
                            case "X" -> "Cubic Meters"
                            case "C" -> "Cubic Feet"
                            else -> "Unknown"
                        }
                    }
                })
            }
        }
    }
}
