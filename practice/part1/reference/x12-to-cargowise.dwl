%dw 2.0
output application/xml
import * from dw::core::Strings
import * from dw::core::Periods
var BookingNum = substringAfter( payload.Booking.TransactionSets.v004010."300"[0].Heading."020_B1".B102, "SHIP") * 8989
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
var PortofDischarge = payload.Booking.TransactionSets.v004010."300"[0].Heading."130_R4_Loop"."130_R4" filter ((item, index) -> item.R401 == "E" ) reduce ((item, accumulator) -> item )
var portofloading =  payload.Booking.TransactionSets.v004010."300"[0].Heading."130_R4_Loop"."130_R4" filter ((item, index) -> item.R401 == "L" ) reduce ((item, accumulator) -> item )
var PortOfDelivery = payload.Booking.TransactionSets.v004010."300"[0].Heading."130_R4_Loop"."130_R4" filter ((item, index) -> item.R401 == "D" ) reduce ((item, accumulator) -> item)
var PortOfOrigin = payload.Booking.TransactionSets.v004010."300"[0].Heading."130_R4_Loop"."130_R4" filter ((item, index) -> item.R401 == "R" ) reduce ((item, accumulator) -> item)
---
{
    "UniversalShipment": {
        "Shipment":{
            "DataSourceCollection": {
                "DataSource":[
                    {
                        "Type": "BookingConformation",
                        "Value": "SOO" ++ BookingNum
                    }
                ]

            },
            "BookDate": now() + |PT6H|,
            "CompanyCode": payload.Booking.TransactionSets.v004010."300"[0].Heading."020_B1".B101,
            "OrganizationAddressCollection": {
                "OrgAddress": payload.Booking.TransactionSets.v004010."300"[0].Heading."080_N1_Loop" map ((item, index) -> {
    "AddressType": Addresses[item."080_N1".N101],
    "Address": item."100_N3".N301 reduce ((item, accumulator) -> item),
    "City": item."110_N4".N401,
    "CompanyName": item."080_N1".N102,
    "Country": {
        "Code": item."110_N4".N404,
        "Name": CountryCodeLists[item."110_N4".N404]
        },
    "City": item."110_N4".N401,
    "StateCode": item."110_N4".N402,
    "PostalCode": item."110_N4".N403,
    "ContactName": item."120_G61".G6102 reduce ((item, accumulator) -> item),
    "Mail": item."120_G61".G6104 reduce ((item, accumulator) -> item )
})
            },
    "TransportMode":"SEA",
    "ActualChargableAmount": substring(payload.Booking.TransactionSets.v004010."300"[0].Heading."020_B1".B102, 8,10) as Number * 40,
    "BookiongConformationReference": "",
    "Branch": {
        "Code": "047",
        "Name": "Bngalore(main)"
    },
    "ContainerMode": {
        "Code": "LSE",
        "Description": "Loose"
    },
    "EntryStatus": {
        "Code": "OCC",
        "Description": "Cleared all stages"
    },
    "GoodsDescription": "Dont accepts if seals are broken or open",
    "GoodsVlaueCurrency":{
        "Code": "INR",
        "Description": "Indian Rupees"
    },
    "InsuranceValue": 0.000,
    "MessageType": {
        "Code": "EXP",
        "Description": "Export Service"
    },
    "PaymentMethod": {
        "Code": "PP",
        "Description": "Prepaid"
    },
    "PortofDischarge": {
    "Code": PortofDischarge."R403",
    "Name": PortofDischarge."R404"
    },
    "PortOfLoading": {
    "Code": portofloading."R403",
    "Name": portofloading."R404"
    },
    "PortOfDelivery": {
        "Code": PortOfDelivery."R403",
        "Name": PortOfDelivery."R404"
    },
    "PortOfOrigin": {
        "Code": PortOfOrigin."R403",
        "Name": PortOfOrigin."R404"
    },
    "ServiceLevel": {
        "Code": "STD",
        "Description": "Standard House Shifting"
    },
    "TotalNoOfPacks": sum(payload.Booking.TransactionSets.v004010."300"[0].Detail."010_LX_Loop"."040_L0".L008),
    "TotalVolume": sum(payload.Booking.TransactionSets.v004010."300"[0].Detail."010_LX_Loop"."040_L0".L006),
"TotalVolumeunits": {
    "Code": if (payload.Booking.TransactionSets.v004010."300"[0].Detail."010_LX_Loop"."040_L0".L007[0] == "X") "M3" else "C3",
    "Descripton": "Cubicmeters"
},
"TotalWeight": sum(payload.Booking.TransactionSets.v004010."300"[0].Detail."010_LX_Loop"."040_L0".L004),
"TotalWeightUnits": {
    "Code":if(payload.Booking.TransactionSets.v004010."300"[0].Detail."010_LX_Loop"."040_L0".L011[0] == "K") "KG" else null,
    "Descripton": "Kilograms"
},
"VesselName": payload.Booking.TransactionSets.v004010."300"[0].Detail."090_V1".V102[0],
"VoyageHeightNo": 87979,
"WaybillNumber": "123e4567-e89b-12d3-a487-4366908653338",
"WaybillType": {
    "Code": "MWB",
    "Description": "Master Way Bill Number"
},
"LocalProcessing": {
    "DeliveryDate": now() + days(2),
    "PickUpDate": payload.Booking.TransactionSets.v004010."300"[0].Heading."020_B1".B103,
    "OrderCollection": {
    "OrderNumber": payload.Booking.TransactionSets.v004010."300"[0].Heading."069_N9" map ((item, index) -> {
        "OrderReference": item.N902,
        "Sequence": index+1,
        "ReferenceType": item.N901
    })
}
},
"ContainerCollection": {
        "Container": [
            {
                "Type": "40GP",
                "Description": "40ft General Purpose",
                "ContainerNumber": "MIEU" ++ substring(payload.Booking.TransactionSets.v004010."300"[0].Heading."069_N9".N902[0], 6,10)
            }
        ]
    },

"DateCollection": {
        "Date":[
            {
                "Type": "EstomatedDelivery",
                "Value": now( ) + |P2D|
            },
            {
                "Type": "EstomatedPickup",
                "Value": payload.Booking.TransactionSets.v004010."300"[0].Heading."020_B1".B103
            }
        ]
    },
    "PackingLineCollection":{
        "PackingLine": payload.Booking.TransactionSets.v004010."300"[0].Detail."010_LX_Loop" map ((item, index) -> {
            "Commodity": {
                "Code": "G",
                "Description": "General Cargo"
            },
            "ContainerNumber": "MIEU" ++ substring(payload.Booking.TransactionSets.v004010."300"[0].Heading."069_N9".N902[0], 6,10),
            "GoodsDescription": payload.Booking.TransactionSets.v004010."300"[0].Detail."110_K1".K102[0],
            "PackQty": item."040_L0".L008,
            "PackType":{
                "Code": item."040_L0".L009,
                "Description": "Packages"
            },
            "Weight": item."040_L0".L004,
            "WeightUnit": {
                "Code": item."040_L0".L011 match  {
                case "K" -> "KG"
                case "L" -> "LB"
            },
            "Description": item."040_L0".L011 match  {
                case "K" -> "Kilograms"
                case "L" -> "Pounds"
            },
            },
            "Volume": item."040_L0".L006,
            "WeightUnit": {
                "Code": item."040_L0".L007 match  {
                case "X" -> "M3"
                case "C" -> "C3"
            },
            "Description": item."040_L0".L007 match  {
                case "X" -> "Cubic Meters"
                case "C" -> "Cubic Feet"
            },
            }
        } )
    }



        }


    }
}
