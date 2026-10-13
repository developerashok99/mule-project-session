%dw 2.0
output application/java
var CN = payload.Address filter ((item, index) -> item.AddressType == "Consignee" ) reduce ((item, accumulator) -> item )
var FW = payload.Address filter ((item, index) -> item.AddressType == "Forwarder" ) reduce ((item, accumulator) -> item )
var SH = payload.Address filter ((item, index) -> item.AddressType == "Shipper" ) reduce ((item, accumulator) -> item)
---
{
    "TransactionSets":{
        "v004010": {
            "300": [
                {
                    "Heading":
                    {
                        "050_Y1":
                        {
            	            "Y103": payload.SCAC,
            	            "Y105": "SH",
            	            "Y108": "PP"
        		        },
                        "020_B1": {
			                "B102": payload.ShipmentID,
                            "B104": if(payload.ActionCode == "Create") "N"  else "R",
                            "B101": payload.SCAC,
                            "B103": payload.ShipDate as Date
			            },
                        "080_N1_Loop":
                        [
                            {
                                "080_N1":{
                                    "N101": "FW",
                                    "N102": FW.CompanyName
                                },
                                "100_N3":[
                                {
                                    "N301": FW.Address
                                }
                                ],
                                "110_N4":{
                                    "N401": FW.City,
                                    "N402": FW.State,
                                    "N403": FW.PostalCode,
                                    "N404": FW.Country
                                },
                                "120_G61":[
                                {
                                    "G6101": "CN",
                                    "G6102": FW.ContactName,
                                    "G6103": "EM",
                                    "G6104": FW.ContactMail
                                }
                                ]
                            },
                            {
                                "080_N1": {
                                    "N101": "CN",
                                    "N102": CN.CompanyName,
                                },
                                "100_N3": [
                                    {
                                        "N301": CN.Address
                                    }
                                ],
                                "110_N4": {
                                    "N401": CN.City,
                                    "N402": CN.State,
                                    "N403": CN.PostalCode,
                                    "N404": CN.Country
                                },
                                "120_G61":[
                                    {
                                        "G6101": "CN",
                                        "G6102": CN.ContactName,
                                        "G6103": "EM",
                                        "G6104": CN.ContactMail
                                    }
                                ]
                            },
                            {
                                "080_N1": {
                                    "N101": "SH",
                                    "N102": SH.CompanyName,
                                },
                                "100_N3": [
                                    {
                                        "N301": SH.Address
                                    }
                                ],
                                "110_N4": {
                                    "N401": SH.City,
                                    "N402": SH.State,
                                    "N403": SH.PostalCode,
                                    "N404": SH.Country
                                },
                                "120_G61":[
                                    {
                                        "G6101": "CN",
                                        "G6102": SH.ContactName,
                                        "G6103": "EM",
                                        "G6104": SH.ContactMail
                                    }
                                ]
                            }
                        ],
                        "130_R4_Loop":
                        [
                            {
                                "130_R4":{
                                    "R401": "R",
                                    "R403": payload.PlaceofReceipt.Code,
                                    "R404": payload.PlaceofReceipt.Name
                                }
                            },
                            {
                                "130_R4":{
                                    "R401": "L",
                                    "R403": payload.PortofLoading.Code,
                                    "R404": payload.PortofLoading.Name
                                }
                            },
                            {
                                "130_R4":{
                                    "R401": "D",
                                    "R403": payload.PortofDischarge.Code,
                                    "R404": payload.PortofDischarge.Name
                                }
                            },
                            {
                                "130_R4":{
                                    "R401": "E",
                                    "R403": payload.PlaceofDelivery.Code,
                                    "R404": payload.PlaceofDelivery.Name
                                }
                            }
                        ],
                        "140_DTM":
                        [
                            {
                                "DTM_02": payload.DeliveryDate
                            }
                        ],
                        "069_N9":
                        [
                            {
                                "N901": payload.ReferenceCollection.BookingReference.Type [0],
                                "N902": payload.ReferenceCollection.BookingReference.Number [0]
                            }
                        ]
                    },
                    "Summary":{},
                    "Detail":{
                        "010_LX_Loop": payload.Packages map ((item, index) -> {
                            	"010_LX" :{
                            		"LX01": index + 1
                            	},
                                "040_L0": {
                                    "L004": item.Weight,
                                    "L011": if(item.WeightUOM.Code == "KG") "K" else null,
                                    "L006": item.Volume,
                                    "L007": if(item.VolumeUOM.Code == "M3") "X" else null,
                                    "L008": item.PackQty as Number,
                                    "L009": item.PackageType.Code
                                }
} ),
                        "090_V1":[
                            {
                                "V102": payload.VesselName,
                                "V101": payload.VesselIMO
                            }
                        ],
                        "110_K1":[
                            {
                                "K101": payload.NoteCollection.NoteType [0],
                                "K102": payload.NoteCollection.NoteText [0]
                            }
                        ]
                    }
                }
            ]
        }
    }
}
