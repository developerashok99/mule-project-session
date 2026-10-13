# Project Session Part 1 — Super-Detailed Notes

**Molson Coors → CargoWise booking integration: how it works, how to explain it in an interview, and how to build it yourself.**

Source: the Part 1 mentoring session ([cleaned transcript](../transcripts/part1.md), [slides](../slides/part1/README.md)). Times in brackets like *(33:51)* point to that moment in the video.

> **How to read these notes.** Each section has two kinds of content.
> - **From the session:** what the mentor actually said or showed.
> - **Background / how-to:** extra explanation added so you can understand and build it. These parts are marked with 🔧.
> - **The mentor's reference files** (sample EDI, X12 Read output, and the X12 → CargoWise and JSON → X12 mappings, shared by email after the session) are in [practice/part1/reference/](../practice/part1/reference/). Both mappings were run with the DataWeave engine to check them; see [11.7](#117-bugs-found-by-running-the-mapping) and [12.2](#122-the-reverse-mapping-json--edi-300-with-x12-write).

## Contents

1. [The big picture of this session](#1-the-big-picture-of-this-session)
2. [Job-search plan and recruiter calls](#2-job-search-plan-and-recruiter-calls)
3. [MuleSoft basics the mentor checked](#3-mulesoft-basics-the-mentor-checked)
4. [Design question: the same transaction ID sent twice](#4-design-question-the-same-transaction-id-sent-twice)
5. [Why you present one simple project](#5-why-you-present-one-simple-project)
6. [The business: Molson Coors and CargoWise](#6-the-business-molson-coors-and-cargowise)
7. [EDI and the EDI 300 file, line by line](#7-edi-and-the-edi-300-file-line-by-line)
8. [The integration flow, step by step](#8-the-integration-flow-step-by-step)
9. [The interview script (memorise this)](#9-the-interview-script-memorise-this)
10. [Connections, security, error handling, CI/CD](#10-connections-security-error-handling-cicd)
11. [The practice task, explained in full](#11-the-practice-task-explained-in-full)
12. [Page two: EDI going back out (301, and JSON → EDI 300)](#12-page-two-edi-going-back-out)
13. [Interview questions and answers](#13-interview-questions-and-answers)
14. [Glossary](#14-glossary)
15. [One-page revision sheet](#15-one-page-revision-sheet)

---

## 1. The big picture of this session

The session has three goals:

1. **Get you ready for recruiter and HR calls** (0:00–4:58).
2. **Check your MuleSoft basics** and how you think through a design problem (4:59–16:34).
3. **Give you one realistic project to talk about**, and a practice task so you can build it and talk about it with confidence (16:38–42:49).

```mermaid
flowchart TD
    A["Session Part 1"] --> B["Job-search plan<br/>(0:00)"]
    A --> C["MuleSoft basics<br/>(4:59)"]
    A --> D["Design question:<br/>duplicate transaction ID<br/>(10:23)"]
    A --> E["Project:<br/>Molson Coors → CargoWise<br/>(19:21)"]
    E --> E1["Business story"]
    E --> E2["EDI 300 file"]
    E --> E3["Flow: SFTP → X12 Read →<br/>JSON → XML → eAdaptor"]
    E --> E4["Interview script<br/>(33:01)"]
    E --> E5["Practice task<br/>(38:19)"]
```

**The one thing to take away:** in an interview, describe *one* project in *one* simple flow, in the first 5–10 minutes, so clearly that the interviewer understands the business. Everything else in this session supports that.

---

## 2. Job-search plan and recruiter calls

### 2.1 Timeline the mentor proposed *(0:00)*

| When | What |
|---|---|
| This week | Make your profile (you offered to start right away) |
| ~1 week after the profile goes up | Expect the first calls |
| 17th–24th | Mentor travelling to Bangalore |
| From the 26th | Résumé preparation together |

### 2.2 What HR asks on the first call *(0:36–2:09)*

Keep **three things** ready:

1. **Roles and responsibilities as a MuleSoft developer.** HR often reads questions from the job description (JD). Answer with points that **match the JD**: API-led connectivity, Choice router, connectors, and so on. Then explain your responsibilities in your own words.
2. **Experience:** total experience, and **relevant MuleSoft experience**.
3. **Money and availability:** **current CTC**, **expected CTC**, **notice period**, and when you are available for interviews.

> *(2:06)* If a company has had an opening for a while, they move fast on a candidate who fits.

🔧 **A ready answer for "What do you do as a MuleSoft developer?"**
> "I design and build integrations in Anypoint Studio, following API-led connectivity. I build flows with connectors such as SFTP, File, HTTP and X12, transform data with DataWeave, use routers like Choice and Scatter-Gather, and implement global error handling and logging. I secure APIs with policies like Client ID Enforcement, keep secrets in secure property files, and deploy to CloudHub 2.0 through CI/CD pipelines."

### 2.3 Track every company *(2:41–4:08)*

You said you'll handle the first calls yourself. The mentor's rule: **note down every company that calls, keep the list, and update each company's status every day.**

🔧 A simple tracker:

| Date | Company / vendor | Role | Round | Status | Next step |
|---|---|---|---|---|---|
| 26-10 | ABC Tech | MuleSoft Dev | HR screen | Shortlisted | L1 on 28-10, 3 pm |

### 2.4 The hiring process *(4:15–4:58)*

```mermaid
flowchart LR
    A["Résumé<br/>submitted"] --> B["Résumé<br/>processed"]
    B --> C{"Shortlisted?"}
    C -->|yes| D["HR call:<br/>availability"]
    D --> E["Technical<br/>round(s)"]
    E -->|"feedback,<br/>next round"| E
    E --> F["Client round<br/>(if any)"]
    F --> G["Documents<br/>collected"]
    G --> H["Offer letter"]
    C -->|no| X["Track & move on"]
```

---

## 3. MuleSoft basics the mentor checked

### 3.1 "What styles of architecture are there?" *(5:01)*

You answered **MVC (Model–View–Controller)**: business logic is kept separate from presentation, and **architecture makes debugging easier**. The mentor accepted it as the basic concept, then moved to the real question: *why MuleSoft?*

### 3.2 Why MuleSoft: the database example *(5:37–8:28)*

**Without an integration layer**, every project that touches the company's SQL database must build its own DB connection and its own queries (create, read, update, delete user accounts, and so on). That one database ends up wired into every project.

**With MuleSoft**, one API sits in front of the database. Projects call **endpoints** like `POST /users` to insert or `GET /users` to query, instead of talking to the database directly. The API is built once from a set of requirements and reused everywhere.

```mermaid
flowchart LR
    subgraph Before["Without integration layer"]
        P1["Project A"] -->|"own connection<br/>+ SQL"| DB1[("SQL DB")]
        P2["Project B"] -->|"own connection<br/>+ SQL"| DB1
        P3["Project C"] -->|"own connection<br/>+ SQL"| DB1
    end
    subgraph After["With MuleSoft API"]
        Q1["Project A"] -->|"POST /users"| API["Mule API<br/>(built once)"]
        Q2["Project B"] -->|"GET /users"| API
        Q3["Project C"] -->|"PUT /users/:id"| API
        API --> DB2[("SQL DB")]
    end
```

**Interview line:** "MuleSoft is an integration layer. Instead of every system connecting point-to-point, we expose reusable APIs, so a new project only needs the API details, not the database or system internals."

### 3.3 Integration patterns mentioned *(8:31–9:46)*

| Pattern | What it means | Mentioned as |
|---|---|---|
| **API-led connectivity** | APIs in three layers: Experience → Process → System | What the mentor mainly works on |
| **ETL** (Extract, Transform, Load) | Pull data out, reshape it, load it into a target | Another integration pattern |
| **Workflow-based** | One workflow per customer; a new customer gets a new workflow | How the mentor's current company works |
| **Single-layer** | The whole integration in one app | How the sample project is presented |

🔧 **API-led connectivity in one picture**, and where this project would fit if it were split into layers:

```mermaid
flowchart TB
    subgraph EXP["Experience layer — shapes data for a consumer"]
        E1["(not needed here: no UI / mobile consumer)"]
    end
    subgraph PRC["Process layer — business logic & orchestration"]
        P1["booking-process-api<br/>EDI JSON → CargoWise XML"]
    end
    subgraph SYS["System layer — talks to one system each"]
        S1["sftp-system-api<br/>pick up EDI 300 files"]
        S2["cargowise-system-api<br/>POST XML to eAdaptor"]
    end
    S1 --> P1 --> S2
```

> The mentor deliberately presents the project as **single-layer** *(32:12)*, because that's easier to explain. If an interviewer asks about API-led, you can describe the split above.

---

## 4. Design question: the same transaction ID sent twice

### 4.1 The question *(10:23)*

> A source system sends a **JSON payload with a unique transaction ID**. You **store** it and then **call a target system**. Later, the **same transaction with the same ID** arrives again. What do you do?

This is the classic **idempotency / duplicate check** problem.

### 4.2 Your answer and the mentor's guidance *(12:27–16:15)*

- **You:** a POST API inserts the ID into a DB and calls the target. On the next call, check the DB: if the ID is new, insert; if it exists, **update** (PUT/PATCH) and send to the target.
- **Mentor:** right concept, but answer *in MuleSoft terms*. It doesn't have to be a DB: think **Object Store**, or even a **local file system**.
- **Mentor's file-system version:** store the ID with **Set Variable**, use the File connector's **List** operation to get all file names, **filter** by file name, and **update** if it already exists.

```mermaid
flowchart TD
    A["Request arrives<br/>{ transactionId, ... }"] --> B["Set Variable<br/>txnId = payload.transactionId"]
    B --> C{"Seen this txnId<br/>before?"}
    C -->|"No — new"| D["Store record<br/>(Object Store / file / DB)"]
    C -->|"Yes — duplicate"| E["Update existing record<br/>(or skip / return 'already processed')"]
    D --> F["Call target system"]
    E --> F
    F --> G["Respond to source"]
```

### 4.3 🔧 Three ways to build it in Mule 4

**Option A: the built-in Idempotent Message Validator (the simplest answer to give).**
It checks an ID against an Object Store and throws `MULE:DUPLICATE_MESSAGE` if the ID has been seen before.

```xml
<flow name="txn-flow">
    <http:listener config-ref="HTTP_Listener_config" path="/transactions"/>
    <idempotent-message-validator idExpression="#[payload.transactionId]"
                                  objectStore="txnStore"/>
    <!-- only first-time IDs reach here -->
    <http:request config-ref="Target_Config" method="POST" path="/target"/>
    <error-handler>
        <on-error-continue type="MULE:DUPLICATE_MESSAGE">
            <set-payload value='#[{ status: "duplicate", transactionId: payload.transactionId }]'/>
        </on-error-continue>
    </error-handler>
</flow>
```

**Option B: Object Store `contains` + `store` (when duplicates must update instead of skip).**

```xml
<set-variable variableName="txnId" value="#[payload.transactionId]"/>
<os:contains key="#[vars.txnId]" objectStore="txnStore" target="exists"/>
<choice>
    <when expression="#[vars.exists]">
        <logger level="INFO" message="#['Duplicate ' ++ vars.txnId ++ ' — updating']"/>
    </when>
    <otherwise>
        <logger level="INFO" message="#['New ' ++ vars.txnId]"/>
    </otherwise>
</choice>
<os:store key="#[vars.txnId]" objectStore="txnStore">
    <os:value>#[payload]</os:value>
</os:store>   <!-- store overwrites, so it works as insert OR update -->
<http:request config-ref="Target_Config" method="POST" path="/target"/>
```

**Option C: the local file system (the mentor's version).** Each record is saved as `<transactionId>.json`.

```xml
<set-variable variableName="txnId" value="#[payload.transactionId]"/>
<set-variable variableName="record" value="#[payload]"/>
<file:list config-ref="File_Config" directoryPath="${store.dir}"/>
<set-variable variableName="exists"
    value="#[sizeOf(payload filter ((f) -> f.attributes.fileName == vars.txnId ++ '.json')) > 0]"/>
<file:write config-ref="File_Config" path="#['${store.dir}/' ++ vars.txnId ++ '.json']"
            mode="OVERWRITE">
    <file:content>#[output application/json --- vars.record]</file:content>
</file:write>
```

| | Idempotent Validator | Object Store | File system | Database |
|---|---|---|---|---|
| Effort | Lowest | Low | Medium | Medium |
| Can update a duplicate? | No (rejects it) | Yes | Yes | Yes |
| Survives restarts? | Yes, with a persistent OS | Yes, with a persistent OS | Yes | Yes |
| Shared across workers? | With CloudHub OS v2 | With CloudHub OS v2 | No (local disk) | Yes |

**Interview line:** "I'd use the Idempotent Message Validator backed by a persistent Object Store, keyed on the transaction ID. If the business wants duplicates to update instead of being rejected, I'd use `os:contains` with a Choice router, then `os:store`, which overwrites."

---

## 5. Why you present one simple project

*(16:38–19:40)* The mentor's reasoning:

- Real work is **workflow-based**: one workflow per project.
- If you explain a full ETL architecture, **the interviewer gets confused**, and confusion brings **cross-questions** you can't control.
- So use a **single, simple project** that shows the business clearly.
- This description is **the most important part of the interview**: you'll spend the **first 5–10 minutes** on it. It's the intro that grabs attention, so say it **realistically**. You can use the mentor's words or improve on them.
- *(42:25)* Explain **page one only**. If you say too much, the interviewer won't follow. **Simple and clear.**

---

## 6. The business: Molson Coors and CargoWise

### 6.1 The two systems *(19:56–22:29)*

| | **Molson Coors** | **CargoWise** |
|---|---|---|
| Role | **Source system** | **Target system** |
| What it is | Multinational drink and brewing company, formed by the 2005 merger of Molson (Canada) and Coors (US). HQ Chicago; 5th largest brewer globally *(slide 02)* | **Shipment management tool**: logistics software used by freight forwarders and logistics providers |
| Brands (in case they ask) | Coors Light, Miller Lite, Molson Canadian, Carling, Blue Moon *(slide 02)* | — |
| What it sends or accepts | Sends **EDI 300** booking files | Accepts **XML, in specific modules**, through the **eAdaptor** |

### 6.2 The business problem *(20:52–24:58)*

Molson Coors ships to many countries, so it needs a **logistics partner**, and it wants its bookings to flow into **CargoWise**. Its systems and CargoWise are different, so they hired an integration company that uses MuleSoft. *"That's why we are here."*

**Before (manual):**

```mermaid
sequenceDiagram
    participant MC as Molson Coors
    participant Op as Operator
    participant CW as CargoWise
    MC->>Op: Phone call / email with booking details
    Op->>Op: Read the email
    Op->>CW: Type everything into the booking form
    CW-->>Op: Booking created
    Note over MC,CW: Slow, manual, typing errors
```

**After (automated with MuleSoft):**

```mermaid
sequenceDiagram
    participant MC as Molson Coors
    participant SFTP as SFTP server
    participant Mule as Mule app
    participant CW as CargoWise (eAdaptor)
    MC->>SFTP: Drop booking as EDI 300 file
    Mule->>SFTP: Pick up file (SFTP connector)
    Mule->>Mule: X12 Read: EDI 300 → JSON
    Mule->>Mule: DataWeave: JSON → CargoWise XML
    Mule->>CW: HTTPS POST XML
    CW-->>Mule: Accepted (booking created)
    Note over MC,CW: "Whenever we get a booking, we create it in CargoWise" (24:58)
```

---

## 7. EDI and the EDI 300 file, line by line

### 7.1 What EDI is *(25:04–25:36)*

- **EDI = Electronic Data Interchange.** Companies use it to exchange business documents (orders, invoices, bookings) in a **standard, flat-file, structured format**.
- **ANSI X12** is the North American EDI standard. Each document type has a number: **300** is a booking request.
- **Version:** this project uses **004010** ("4010") *(25:45)*.
- *(26:28)* "All the integration in Molson Coors is based on these files."

### 7.2 How an X12 file is built

🔧 Three layers of envelopes, like letters inside an envelope inside a parcel:

```mermaid
flowchart TB
    subgraph ISA["ISA … IEA — Interchange (the parcel: who sent it to whom)"]
        subgraph GS["GS … GE — Functional group (the envelope: a group of similar documents)"]
            subgraph ST["ST … SE — Transaction set 300 (the letter: one booking)"]
                B["B1 · G61 · N1/N3/N4 · R4 · Y2 · L5"]
            end
        end
    end
```

**Delimiters** (the characters that split the file up):

| Character | Meaning | Example |
|---|---|---|
| `~` | Segment terminator (end of line/record) | `ST*300*0001~` |
| `*` | Element separator (between fields) | `B1*OOLU*BKG9876543` |
| `>` | Sub-element separator (last char of ISA) | — |

### 7.3 The sample file from the session

*(26:33, slides 04 and 07)* The `ISA` line was cut off on screen; here it's written out in full. This sample is good for **learning the segments**; for building the task, use the mentor's emailed file in [7.6](#76-the-mentors-reference-edi-300-shared-by-email), which is proven to parse.

```
ISA*00*          *00*          *ZZ*SHIPPER1       *ZZ*CARRIEROCEAN   *261010*1155*U*00401*000000101*0*T*>~
GS*SO*SHIPPER1*CARRIEROCEAN*20261010*1155*101*X*004010~
ST*300*0001~
B1*OOLU*BKG9876543*20261010*N~
G61*IC*JOHN DOE*TE*5551234567~
N1*SH*GLOBAL SHIPPER INC.*93*12345~
N3*123 LOGISTICS WAY~
N4*SHANGHAI*SH*200000*CN~
N1*CN*WEST COAST DISTRIBUTORS*94*67890~
N3*789 WAREHOUSE BLVD~
N4*LOS ANGELES*CA*90001*US~
R4*L*UN*CNSHA*SHANGHAI~
R4*D*UN*USLAX*LOS ANGELES~
Y2*1*40FT*40G0~
L5*1*ELECTRONIC COMPONENTS*G*8504.40~
SE*14*0001~
GE*1*101~
IEA*1*000000101~
```

> ⚠️ **One fix from the on-screen sample:** the screen showed `SE*13*0001~`, but `SE01` must equal the number of segments from `ST` to `SE` inclusive, and here that's **14**. A wrong count can make X12 Read report a validation error, so `SE*14` is used above.

### 7.4 Every segment explained

| Segment | Name | Fields in this sample | Business meaning *(26:35–27:20)* |
|---|---|---|---|
| `ISA` | Interchange header | `ZZ*SHIPPER1` → `ZZ*CARRIEROCEAN`, date 261010, time 1155, version 00401, control 000000101, `T` = test | Who is sending to whom; the outer envelope |
| `GS` | Functional group header | `SO`, SHIPPER1 → CARRIEROCEAN, 20261010, group control 101, `X` = X12, **`004010`** | Groups transactions; carries the **version** |
| `ST` | Transaction set header | **`300`**, control `0001` | "This is a **booking request**" |
| `B1` | Beginning segment for booking | Carrier `OOLU`, booking no. **`BKG9876543`**, date 20261010, action `N` (new) | **Booking number** |
| `G61` | Contact | `IC` (information contact), **JOHN DOE**, `TE` (telephone) 5551234567 | **Contact information** |
| `N1` | Party name | `SH` = **shipper**: Global Shipper Inc. / `CN` = **consignee**: West Coast Distributors | Who sends, who receives |
| `N3` | Address | 123 Logistics Way / 789 Warehouse Blvd | **Addresses** |
| `N4` | City/state/zip/country | Shanghai, CN / Los Angeles, CA 90001, US | Addresses (cont.) |
| `R4` | Port | `L` = port of **loading**: CNSHA Shanghai / `D` = port of **discharge**: USLAX Los Angeles | **Route details**: where loading and unloading happen |
| `Y2` | Container | 1 × **40FT**, type `40G0` (40 ft general purpose) | "I need a 40-foot general-purpose container" |
| `L5` | Cargo description | **ELECTRONIC COMPONENTS**, `G` = gross weight, **8504.40** | What is being shipped |
| `SE` | Transaction set trailer | 14 segments, control `0001` (matches `ST02`) | End of the booking |
| `GE` | Group trailer | 1 transaction, control 101 (matches `GS06`) | End of the group |
| `IEA` | Interchange trailer | 1 group, control 000000101 (matches `ISA13`) | End of the file |

**Rule to remember:** every header has a matching trailer with the **same control number**: `ST02 = SE02`, `GS06 = GE02`, `ISA13 = IEA02`.

### 7.5 Related transactions *(slide 03; 34:13; 42:02)*

| Code | Name | Direction in this project |
|---|---|---|
| **300** | Reservation (Booking Request), Ocean | Molson Coors → us → CargoWise |
| **301** | Confirmation (Booking), Ocean | CargoWise → us → Molson Coors (*page two*) |
| **303** | Booking cancellation | Shipper → carrier |
| **304** | Shipping instructions (used to make the bill of lading) | Mentioned: "we get 304 like that" |

### 7.6 The mentor's reference EDI 300 (shared by email)

The mentor later emailed a fuller, real-shaped sample. This is the file to practise with: [practice/part1/reference/booking-300.edi](../practice/part1/reference/booking-300.edi). It parses with X12 Read, and its parsed output is in [x12-read-output.json](../practice/part1/reference/x12-read-output.json).

```
ISA*00*          *00*          *ZZ*QUINOXT        *ZZ*FLKRTT         *230409*2021*U*00401*000000004*0*P*>~
GS*RO*QUINOX*FLKRT*20230409*2021*1*X*004010~
ST*300*0001~
B1*MUHB*SHIP006792*20230417*R~
Y1***MUHB**SH***PP~
N9*Reference*8687564658~
N1*FW*Quinnox~
N3*23,24, 3rd floor, AMR Tech Park 4, Bomanahalli~
N4*Bangalore*KA*560068*IN~
G61*CN*Kodi Angel*EM*kodi.angel@quinnox.com~
N1*CN*Flipkart Internet Pvt Ltd~
N3*Embassy Tech Village Road~
N4*Bangalore*KA*560103*IN~
G61*CN*Edvin Ryding*EM*Edvin.Ryding@flipkart.com~
N1*SH*Tesla Motors~
N3*1 Tesla Road Austin~
N4*Austin*TX*78725*US~
G61*CN*Stan Lee*EM*Stan.Lee@teslamotors.com~
R4*R**INBLR5*Bangalore~
R4*L**INBLR5*Bangalore~
R4*D**USHOU*Houston~
R4*E**USHOU*Houston~
LX*1~
L0****280**878*X*80*PKG**K~
LX*2~
L0****280**878*X*80*PKG**K~
LX*3~
L0****280**878*X*80*PKG**K~
LX*4~
L0****280**878*X*80*PKG**K~
V1*9448815* COSCO~
K1*Goods Description*Handle with care~
SE*31*0001~
GE*1*1~
IEA*1*000000004~
```

**What's new compared with the on-screen sample:**

| Segment | Fields here | Meaning |
|---|---|---|
| `B1` | `MUHB` · `SHIP006792` · 2023-04-17 · `R` | Carrier SCAC, **shipment/booking ID**, date, action (`R` = replace, `N` = new) |
| `Y1` | `MUHB` · `SH` · `PP` | Space reservation: carrier, `SH` shipper, `PP` **prepaid** |
| `N9` | `Reference` · `8687564658` | A **reference number** (the booking reference) |
| `N1` loop ×3 | `FW` Quinnox · `CN` Flipkart · `SH` Tesla Motors | **Forwarder**, **consignee**, **shipper**. Each has its own `N3` address, `N4` city, and a `G61` contact (email this time: `EM`) |
| `R4` ×4 | `R` · `L` · `D` · `E` | All four route points (table below) |
| `LX` + `L0` ×4 | 280 · 878 · `X` · 80 · `PKG` · `K` | **4 package lines**: weight 280 (`K` = kg), volume 878 (`X` = cubic metres), 80 packages of type `PKG` |
| `V1` | `9448815` · ` COSCO` | **Vessel**: IMO number and name (note the leading space) |
| `K1` | `Goods Description` · `Handle with care` | Free-text remark |

**The four `R4` route codes (R401)**, worth memorising:

```mermaid
flowchart LR
    R["R — Place of receipt<br/>INBLR5 Bangalore"] --> L["L — Port of loading<br/>INBLR5 Bangalore"] --> D["D — Port of discharge<br/>USHOU Houston"] --> E["E — Place of delivery<br/>USHOU Houston"]
```

`SE*31`: count `ST` through `SE` and you get 31 (ST, B1, Y1, N9, 3 × (N1, N3, N4, G61) = 12, 4 × R4, 4 × (LX, L0) = 8, V1, K1, SE). ✔

### 7.7 What X12 Read gives you (the real structure)

X12 Read turns the file into one structured object. The mentor's [x12-read-output.json](../practice/part1/reference/x12-read-output.json) shows exactly what you get:

```mermaid
flowchart TB
    ROOT["X12 Read output"] --> TS["TransactionSets.v004010.'300'[ ]<br/>(one entry per booking)"]
    ROOT --> FA["FunctionalAcksGenerated<br/>(997 acknowledgment)"]
    ROOT --> IA["InterchangeAcksGenerated<br/>(TA1 acknowledgment)"]
    ROOT --> ERR["Errors[ ]  ·  Delimiters '*>U~'"]
    TS --> ENV["Interchange (ISA) · Group (GS)<br/>SetHeader (ST) · SetTrailer (SE)"]
    TS --> H["Heading"]
    TS --> DT["Detail"]
    H --> B1["020_B1"]
    H --> Y1["050_Y1"]
    H --> N9["069_N9[ ]"]
    H --> NL["080_N1_Loop[ ]<br/>080_N1 · 100_N3[ ] · 110_N4 · 120_G61[ ]"]
    H --> RL["130_R4_Loop[ ]<br/>130_R4"]
    DT --> LX["010_LX_Loop[ ]<br/>010_LX · 040_L0"]
    DT --> V1["090_V1[ ]"]
    DT --> K1["110_K1[ ]"]
```

**How the keys are named:**
- **Segment key = position in the standard + `_` + segment ID**, e.g. `020_B1`, `110_N4`. You can't guess the positions, so read them from the output.
- **Loops** get `_Loop`: `080_N1_Loop` is the repeating group N1 + N3 + N4 + G61.
- **Repeatable segments are arrays** (`100_N3[ ]`, `120_G61[ ]`, `069_N9[ ]`); single ones are objects (`020_B1`, `110_N4`).
- **Element key = segment ID + 2-digit position**: `B102` is the 2nd field of B1 (the booking ID).
- **Values are typed**: dates become date-times (`B103: "2023-04-17T00:00:00+05:30"`), numbers become numbers (`L004: 280`).

**EDI line → DataWeave path:**

| EDI line | DataWeave path (`b` = `payload.TransactionSets.v004010."300"[0]`) | Value |
|---|---|---|
| `B1*MUHB*SHIP006792*…` | `b.Heading."020_B1".B102` | `SHIP006792` |
| `N9*Reference*8687564658` | `b.Heading."069_N9"[0].N902` | `8687564658` |
| `N1*CN*Flipkart…` | `b.Heading."080_N1_Loop"[1]."080_N1".N102` | `Flipkart Internet Pvt Ltd` |
| `G61*CN*Edvin Ryding*EM*…` | `b.Heading."080_N1_Loop"[1]."120_G61"[0].G6104` | `Edvin.Ryding@flipkart.com` |
| `R4*D**USHOU*Houston` | `(b.Heading."130_R4_Loop"."130_R4" filter ($.R401 == "D"))[0].R403` | `USHOU` |
| `L0****280**878*X*80*PKG**K` | `b.Detail."010_LX_Loop"[0]."040_L0".L004` | `280` |
| `V1*9448815* COSCO` | `b.Detail."090_V1"[0].V102` | `" COSCO"` |

**The free acknowledgments (good interview point).** X12 Read also *generates* the replies the partner expects:
- **TA1** (`InterchangeAcksGenerated`): "your interchange envelope (ISA/IEA) arrived and is valid" (`TA104: "A"` = accepted).
- **997** (`FunctionalAcksGenerated`): "your functional group was accepted" (`AK901: "A"`).

You send these back to the partner with **X12 Write**, so they know the booking file was received and accepted. Note how the sender and receiver are swapped in the ack envelope (`ISA06: CARGO` → `ISA08: FLUENCE`).

> The reference output's envelope (`FLUENCE` → `CARGO`, dated 2023-06-20) comes from a different run than `booking-300.edi` (`QUINOXT` → `FLKRTT`), but the booking data is the same.

---

## 8. The integration flow, step by step

### 8.1 The mentor's final screen *(41:20, slide 10)*

```
MOLSON COORS (WHAT IS THIS COMPANY)                                   SOURCE
CARGOWISE (SHIPMENT MANAGEMENT TOOL) accepts xml in specific modules  TARGET

BOOKINGS --> 300 EDI FILE
file connection -->  file pick from sftp
x12 read -->  300 EDI FILE extract to Json
json -- xml transform --> transform to cargowise booking
sending xml to cargowise -> eAdaptor (https) http request
```

### 8.2 The flow as a diagram

```mermaid
flowchart LR
    MC["Molson Coors<br/>(source)"] -->|"1. booking<br/>EDI 300"| SFTP[("SFTP<br/>inbound folder")]
    SFTP -->|"2. SFTP listener<br/>picks file"| X12["3. X12 Read<br/>EDI 300 → JSON"]
    X12 --> DW["4. Transform Message<br/>JSON → CargoWise XML"]
    DW -->|"5. HTTP Request<br/>HTTPS POST"| EA["CargoWise<br/>eAdaptor"]
    EA --> CW["CargoWise<br/>(target)<br/>booking created"]
    X12 -. "error" .-> GEH["Global error handler<br/>log · ticket · notify"]
    DW -. "error" .-> GEH
    EA -. "error" .-> GEH
```

### 8.3 Each step in detail

**Step 1: Bookings arrive as EDI 300 files** *(25:04)*. Molson Coors produces one EDI 300 per booking (or a batch inside one interchange).

**Step 2: Pick up the file over SFTP** *(27:32–28:52)*.
- Files can arrive by **AS2** or **SFTP**.
- **AS2** is a secure B2B protocol over HTTP, where both trading partners exchange **certificates**. It's harder, and it brings many interview questions.
- The mentor's advice: **say SFTP.** "They put the file, and you pick the file up." Most interviewers know SFTP.
- 🔧 In Mule: the **SFTP connector's `On New or Updated File`** listener polls a folder. Set `autoDelete` or `moveToDirectory` so the same file isn't processed twice.

**Step 3: X12 Read converts EDI → JSON** *(28:52–29:58)*.
- "X12 is a connector in MuleSoft." The **X12 Read** operation **parses the file against the X12 schemas defined in the connector** (for example the 004010 / 300 schema) and gives you structured data.
- Then "you can use it as JSON or anything" and **start mapping**.

**Step 4: Transform JSON → CargoWise XML** *(30:08–31:17)*.
- "CargoWise only accepts **XML in specific modules**." So you transform to the exact XML layout that module expects, using DataWeave in a **Transform Message**.
- The mentor's mapping produces CargoWise's **`UniversalShipment`** XML (a `<UniversalShipment><Shipment>…` document with addresses, ports, packing lines and dates). The full mapping, and what each field comes from, is in [11.6](#116-the-mentors-mapping-explained).

**Step 5: Send to CargoWise via the eAdaptor over HTTPS** *(31:17–31:53)*.
- The **eAdaptor** is CargoWise's integration service ("one of the adapter services"). You **POST the XML over HTTPS** with the **HTTP Request** connector.
- *(32:02)* "This is your complete business, one page of business."

### 8.4 What the data looks like at each stage

Real values from the mentor's reference files:

```mermaid
flowchart LR
    A["<b>EDI 300 (text)</b><br/>B1*MUHB*SHIP006792*20230417*R~<br/>R4*D**USHOU*Houston~"] --> B["<b>X12 Read output</b><br/>Heading.'020_B1'.B102 = 'SHIP006792'<br/>Heading.'130_R4_Loop'[2].'130_R4'.R403 = 'USHOU'"]
    B --> C["<b>CargoWise XML</b><br/>&lt;UniversalShipment&gt;&lt;Shipment&gt;<br/>&lt;PortofDischarge&gt;&lt;Code&gt;USHOU…"]
```

The "extract to JSON" step on the mentor's screen is the X12 Read output itself: it's a structured object, and when you log it as JSON it looks like [x12-read-output.json](../practice/part1/reference/x12-read-output.json). The mentor's mapping goes **straight from that structure to XML** in one Transform Message.

---

## 9. The interview script (memorise this)

*(33:01–37:59)* The mentor's order: **Intro → Experience → Certification → Project → Connections → Security → Error handling → Build & deploy → (questions start).**

```mermaid
flowchart LR
    A["1. Intro"] --> B["2. Overall MuleSoft<br/>experience"] --> C["3. Certification<br/>(if any)"] --> D["4. Latest project:<br/>business flow"]
    D --> E["5. Connections"] --> F["6. Security"] --> G["7. Error handling"] --> H["8. Build & deploy"] --> I["Interviewer<br/>asks questions"]
```

### 9.1 The project (≈ 1.5 minutes)

> "Let me walk you through my latest project. It was the **Molson Coors and CargoWise integration**.
>
> **Molson Coors** was our **source system**. It's a multinational beverages company. **CargoWise** was the **target system**. It's a **shipment management tool** that manages logistics.
>
> Molson Coors ships to many countries, so whenever they have a shipment, they create a **booking**. Earlier, bookings were emailed to operators who typed them into CargoWise manually. We **automated** that.
>
> From Molson Coors we receive the bookings as **EDI 300 files**, version 4010. Similarly we receive other transactions such as the 304. These files contain the **booking information**: booking number, shipper and consignee addresses, contact information, port of loading and port of discharge, container type, and cargo details.
>
> We pick up the files from **SFTP**, and we extract the EDI 300 into **JSON** using the **X12 Read** connector. Then we transform that into **XML** with **DataWeave**, in the format CargoWise expects, because CargoWise accepts XML in specific modules. Finally, we send the XML to CargoWise through its **eAdaptor**, as an **HTTPS** request, and the booking gets created in CargoWise."

### 9.2 Connections *(35:14)*

> "Coming to connections: we built a few APIs for **Fluence**. They work over **SFTP**: we receive the booking files from Fluence through SFTP, and we send the files to CargoWise over **HTTPS** using the **eAdaptor**."

The audio sounded like "Fluent / Fluence". The mentor's reference X12 output confirms the name: its sender ID is `ISA06: FLUENCE` and its receiver is `ISA08: CARGO` ([7.7](#77-what-x12-read-gives-you-the-real-structure)).

### 9.3 Security *(35:44)*

> "We secure our APIs with the **Client ID Enforcement** policy in API Manager, and we secure sensitive values such as passwords in our property files using **Secure Properties** with **AES** encryption."

### 9.4 Error handling *(36:16)*

> "We have **common flows** with a **global error handler**. Whenever there's an issue in any flow, it goes to the global error handler. There we **log the error in a proper format**, store the error message, and **create a ticket** with the **correlation ID**, the error message and the details needed to **retry the same file**. We also **send notifications** to the source and target teams."

### 9.5 Build and deploy *(37:27)*

> "Our code repository was **Bitbucket**. We deploy to **CloudHub 2.0** through **CI/CD with Bitbucket Pipelines**."

### 9.6 Tips for delivering it

- **Page one only.** Don't start with the 301 return flow unless they ask *(42:25)*.
- **Say the business before the tech.** "Bookings were manual; we automated them" makes it real.
- **Use the names**: X12 Read, DataWeave, eAdaptor, Client ID Enforcement, CloudHub 2.0. They signal hands-on work.
- **Practise until it takes about 3 minutes**, without reading.
- After the script, **expect questions** on X12, SFTP, error handling, DataWeave and deployment. See [section 13](#13-interview-questions-and-answers).

---

## 10. Connections, security, error handling, CI/CD

🔧 These sections expand the four short answers in the script so you can survive the follow-up questions.

### 10.1 Connections

| Leg | Protocol | Mule component | Key config |
|---|---|---|---|
| Molson Coors → Mule | **SFTP** | SFTP `On New or Updated File` listener | host, port 22, username, password or key, directory, polling frequency, `moveToDirectory` |
| Mule → CargoWise | **HTTPS** | HTTP Request (eAdaptor URL) | host, port 443, TLS context, path, auth credentials, `Content-Type: application/xml` |
| (Alternative inbound) | **AS2** | AS2 connector | partner IDs, certificates for signing/encryption, MDN receipts |

### 10.2 Security

```mermaid
flowchart LR
    C["Caller"] -->|"client_id +<br/>client_secret headers"| GW["API Manager policy:<br/>Client ID Enforcement"]
    GW -->|"valid"| APP["Mule app"]
    GW -->|"invalid"| R["401 rejected"]
    APP --> P["secure-props.yaml<br/>password: ![AES-encrypted]"]
    K["Encryption key<br/>(runtime property,<br/>not in code)"] --> APP
```

- **Client ID Enforcement:** every caller must send a valid `client_id` and `client_secret` registered in Anypoint Exchange/API Manager.
- **Secure Properties:** passwords are stored encrypted, e.g. `sftp.password: "![x8f…]"`, and read with `${secure::sftp.password}`. The **key** is passed at deploy time, never committed to Git.
- 🔧 Other answers to have ready: TLS/HTTPS on all endpoints, IP allowlisting, rate-limiting policies, OAuth 2.0 for external APIs.

### 10.3 Error handling

```mermaid
flowchart TD
    F["Any flow fails<br/>(X12 parse error, transform error,<br/>CargoWise 4xx/5xx, SFTP down)"] --> G["Global error handler<br/>(common flow)"]
    G --> L["Log in standard format<br/>correlationId · flow · error.description"]
    G --> T["Create ticket<br/>correlationId · error message · file name<br/>(enough to retry the same file)"]
    G --> N["Notify source &<br/>target recipients"]
    T --> RT["Retry the same file<br/>after the fix"]
```

🔧 **In Mule 4:**

```xml
<configuration defaultErrorHandler-ref="global-error-handler"/>

<error-handler name="global-error-handler">
    <on-error-propagate type="X12:PARSE, MULE:EXPRESSION">
        <!-- bad data: log, ticket, notify; do not retry automatically -->
        <flow-ref name="common-log-ticket-notify"/>
    </on-error-propagate>
    <on-error-propagate type="HTTP:CONNECTIVITY, HTTP:SERVICE_UNAVAILABLE">
        <!-- target down: log, ticket; the file can be replayed later -->
        <flow-ref name="common-log-ticket-notify"/>
    </on-error-propagate>
    <on-error-propagate type="ANY">
        <flow-ref name="common-log-ticket-notify"/>
    </on-error-propagate>
</error-handler>
```

- **On Error Propagate:** handles the error, then re-throws it, so the caller or listener sees a failure.
- **On Error Continue:** handles the error and treats the flow as successful.
- **Correlation ID** (`correlationId` in DataWeave): one ID that follows a message through every log line. Put it in the ticket so support can find the exact run.
- 🔧 Exact error type names (e.g. for X12) depend on the connector version; check the error type in the Studio debugger or in your logs.

### 10.4 Build and deploy (CI/CD)

```mermaid
flowchart LR
    D["Developer pushes<br/>to Bitbucket"] --> P["Bitbucket Pipeline<br/>triggered"]
    P --> B["mvn clean package<br/>(+ MUnit tests)"]
    B --> DEP["mvn deploy<br/>mule-maven-plugin"]
    DEP --> CH["CloudHub 2.0<br/>(dev → test → prod)"]
```

🔧 Points for follow-up questions: the **mule-maven-plugin** does the deployment. Environment-specific values live in property files per environment (`dev.yaml`, `prod.yaml`). Secrets (the secure-properties key, Anypoint credentials) are stored as **pipeline repository variables**, not in code.

---

## 11. The practice task, explained in full

*(38:19–41:13)* This is your homework. Build it, and you can honestly say you've done every step in the script. The mentor has since emailed the reference material for it, all saved in [practice/part1/reference/](../practice/part1/reference/):

| File | What it is |
|---|---|
| [booking-300.edi](../practice/part1/reference/booking-300.edi) | The EDI 300 to drop into your File connector |
| [x12-read-output.json](../practice/part1/reference/x12-read-output.json) | What X12 Read produces from it, so you can compare with your log |
| [x12-to-cargowise.dwl](../practice/part1/reference/x12-to-cargowise.dwl) | The mentor's mapping: X12 output → CargoWise `UniversalShipment` XML (as sent) |
| [x12-to-cargowise-fixed.dwl](../practice/part1/reference/x12-to-cargowise-fixed.dwl) | The same mapping with 8 fixes; **use this one** ([11.7](#117-bugs-found-by-running-the-mapping)) |
| [booking-input.json](../practice/part1/reference/booking-input.json) + [json-to-x12-300.dwl](../practice/part1/reference/json-to-x12-300.dwl) | The reverse direction: JSON → X12 300, for generating EDI files ([12.2](#122-the-reverse-mapping-json--edi-300-with-x12-write)) |
| [json-to-x12-300-fixed.dwl](../practice/part1/reference/json-to-x12-300-fixed.dwl) | The reverse mapping with 2 fixes |

> Both mappings were **run with the DataWeave 2.11 engine** (the one bundled with Anypoint Studio) against these files. The expected results in [11.3](#113-how-to-test) are real output, not guesses.

### 11.1 What to build

```mermaid
flowchart LR
    subgraph APP1["App 1: booking-integration"]
        A["File listener<br/>watches /inbound<br/>*.edi"] --> B["X12 Read<br/>004010 / 300"]
        B --> L["Logger<br/>(output as JSON)"]
        L --> D["Transform Message<br/>x12-to-cargowise-fixed.dwl<br/>→ UniversalShipment XML"]
        D --> E["HTTP Request<br/>POST /api/bookings"]
        E --> F["Log confirmation"]
    end
    subgraph APP2["App 2: cargowise-mock (stands in for CargoWise)"]
        G["HTTP listener<br/>POST /api/bookings"] --> H["Validate XML<br/>(booking ref, company, ports)"]
        H --> I["Build confirmation XML<br/>from request fields"]
    end
    E -->|"XML over HTTP"| G
    I -->|"confirmation XML"| E
```

| Mentor's instruction | What it means |
|---|---|
| "Instead of SFTP, just use a **File** connection" | Use the File connector listener on a local folder. Same idea as SFTP, no server needed |
| "Take EDI 300 samples and place them" | Use `booking-300.edi`; make more with the reverse mapping ([12.2](#122-the-reverse-mapping-json--edi-300-with-x12-write)) |
| "Use the **X12 Read** connector" | Parse with the 004010 / 300 schema |
| "Add a **Transform Message** to convert it into JSON" | X12 Read's output *is* the structure you see as JSON. Log it to look at it |
| "I'll give a sample XML / mapping sheet; transform to that XML" | That's `x12-to-cargowise.dwl` → CargoWise **UniversalShipment** XML |
| "In parallel, create **another API**… takes an XML payload… respond with a **confirmation message**… put some validations" | App 2: a mock CargoWise that accepts `UniversalShipment` and returns a confirmation built from it |
| "Deploy this one and keep it" | Run App 2 (locally, or on CloudHub) |
| "After your XML is ready, send the XML" | App 1 calls App 2 with HTTP Request |

### 11.2 Step-by-step build in Anypoint Studio

**Setup**
1. Create folders: `C:\mule\inbound`, `C:\mule\processed` (or the Linux/Mac equivalents).
2. Create Mule project **`booking-integration`**.
3. From Exchange, add the **X12 connector**, the **File connector** and the **Validation module** (HTTP is already included).

**App 1, Step 1: the File listener**

```xml
<file:config name="File_Config">
    <file:connection workingDir="C:\mule"/>
</file:config>

<flow name="booking-from-file">
    <file:listener config-ref="File_Config" directory="inbound"
                   moveToDirectory="processed" recursive="false">
        <scheduling-strategy>
            <fixed-frequency frequency="5000"/>
        </scheduling-strategy>
        <file:matcher filenamePattern="*.edi"/>
    </file:listener>
    <logger level="INFO" message="#['Picked up ' ++ attributes.fileName]"/>
    <!-- next steps go here -->
</flow>
```

**App 1, Step 2: X12 Read**

- **Schema:** 004010 / 300 (in the X12 config, add `/x12/004010/300.esl`).
- **Identity:** in `booking-300.edi` the sender (ISA06) is `ZZ` / `QUINOXT` and the receiver (ISA08) is `ZZ` / `FLKRTT`. You are the receiver, so **self = `FLKRTT`**, **partner = `QUINOXT`**. If your connector version also asks for application (GS) IDs, they are `FLKRT` (self) and `QUINOX` (partner). If the IDs don't match, the read can be rejected.

```xml
<x12:config name="X12_EDI_Config">
    <x12:schemas>
        <x12:schema value="/x12/004010/300.esl"/>
    </x12:schemas>
</x12:config>

<x12:read config-ref="X12_EDI_Config"/>
```

> 🔧 Option and element names vary slightly between X12 connector versions. Build it in Studio's visual editor first, then look at the XML it generates.

**App 1, Step 3: log the X12 Read output and compare**

```xml
<logger level="INFO" message="#[write(payload, 'application/json')]"/>
```

Run it, drop `booking-300.edi` into `inbound`, and compare your log with [x12-read-output.json](../practice/part1/reference/x12-read-output.json). The keys (`020_B1`, `080_N1_Loop`, `130_R4_Loop`, `010_LX_Loop` …) should match; see [7.7](#77-what-x12-read-gives-you-the-real-structure).

**App 1, Step 4: Transform to CargoWise XML**

Paste [x12-to-cargowise-fixed.dwl](../practice/part1/reference/x12-to-cargowise-fixed.dwl) into a Transform Message. The mentor's mapping reads the X12 output under a key called **`Booking`** (`payload.Booking.TransactionSets…`). You have two options:
- add a Transform before it that sets `{ Booking: payload }`, **or**
- change the one alias line at the top of the fixed file to `var booking = payload.TransactionSets.v004010."300"[0]`.

How it works is explained in [11.6](#116-the-mentors-mapping-explained).

**App 1, Step 5: send to App 2**

```xml
<http:request-config name="CargoWise_Mock_Config">
    <http:request-connection host="localhost" port="8082"/>
</http:request-config>

<http:request config-ref="CargoWise_Mock_Config" method="POST" path="/api/bookings">
    <http:headers>#[{ "Content-Type": "application/xml" }]</http:headers>
</http:request>
<logger level="INFO" message="#['CargoWise response: ' ++ write(payload, 'application/xml')]"/>
```

**App 2: `cargowise-mock` (the "second API")**

A second Mule project with its HTTP listener on **port 8082**, so it doesn't clash with App 1. It accepts the `UniversalShipment` XML, checks the key fields, and builds the confirmation **from the request** ("not completely dummy", *39:53*).

```xml
<http:listener-config name="Mock_Listener">
    <http:listener-connection host="0.0.0.0" port="8082"/>
</http:listener-config>

<flow name="receive-booking">
    <http:listener config-ref="Mock_Listener" path="/api/bookings">
        <!-- lets the error handler choose the status code (400 for bad bookings) -->
        <http:error-response statusCode="#[vars.httpStatus default 500]">
            <http:body>#[payload]</http:body>
        </http:error-response>
    </http:listener>
    <set-variable variableName="s" value="#[payload.UniversalShipment.Shipment]"/>
    <validation:is-not-blank-string value="#[vars.s.DataSourceCollection.DataSource.Value]"
        message="Booking reference (DataSource/Value) is required"/>
    <validation:is-not-blank-string value="#[vars.s.CompanyCode]"
        message="CompanyCode is required"/>
    <validation:is-not-blank-string value="#[vars.s.PortOfLoading.Code]"
        message="PortOfLoading/Code is required"/>
    <validation:is-not-blank-string value="#[vars.s.PortofDischarge.Code]"
        message="PortofDischarge/Code is required"/>
    <ee:transform>
        <ee:message>
            <ee:set-payload><![CDATA[%dw 2.0
output application/xml
var s = vars.s
---
BookingConfirmation: {
  BookingReference: s.DataSourceCollection.DataSource.Value,
  Status:           "ACCEPTED",
  ConfirmationRef:  "CW-" ++ s.DataSourceCollection.DataSource.Value,
  Carrier:          s.CompanyCode,
  PortOfLoading:    s.PortOfLoading.Code,
  PortOfDischarge:  s.PortofDischarge.Code,
  Packages:         s.TotalNoOfPacks,
  ReceivedAt:       now() as String { format: "yyyy-MM-dd'T'HH:mm:ss" }
}]]></ee:set-payload>
        </ee:message>
    </ee:transform>
    <error-handler>
        <on-error-propagate type="VALIDATION:BLANK_STRING">
            <set-variable variableName="httpStatus" value="400"/>
            <set-payload value='#[output application/xml --- { BookingError: { Message: error.description } }]'/>
        </on-error-propagate>
    </error-handler>
</flow>
```

### 11.3 How to test

**Expected XML from `booking-300.edi`** (real output of the fixed mapping; dates depend on when you run it):

| Element | Value | Comes from |
|---|---|---|
| `DataSource/Value` | `SOO61053288` | `"SOO" ++` (006792 × 8989) |
| `CompanyCode` | `MUHB` | `B101` |
| `OrgAddress` × 3 | SendingForwarderAddress (Quinnox) · ConsigneeAddress (Flipkart) · LocalClientAddress (Tesla Motors) | `080_N1_Loop` |
| `PortOfOrigin` / `PortOfLoading` | `INBLR5` Bangalore | R4 `R` / `L` |
| `PortofDischarge` / `PortOfDelivery` | `USHOU` Houston | R4 `D` / `E` |
| `TotalNoOfPacks` | `320` | 4 × 80 |
| `TotalWeight` / `TotalVolume` | `1120` / `3512` | 4 × 280 / 4 × 878 |
| `ActualChargableAmount` | `3680` | chars 8–10 of `SHIP006792` = 92, × 40 |
| `ContainerNumber` | `MIEU4658` | `"MIEU" ++` last 4 digits of the N9 reference |
| `VesselName` | `COSCO` | `V102`, trimmed |
| `PackingLine` × 4 | 80 PKG, 280 KG, 878 M3 each | `010_LX_Loop` |

| # | Test | Expected result |
|---|---|---|
| 1 | Start App 2, then App 1. Drop `booking-300.edi` into `inbound` | Log shows the X12 JSON, then a `BookingConfirmation` with `BookingReference SOO61053288`, `Status ACCEPTED`; the file moves to `processed` |
| 2 | Change `R4*E**USHOU*Houston` to `R4*E**USDAL*Dallas` | `PortOfDelivery` = Dallas, `PortofDischarge` still Houston (with the original mapping these come out swapped; see [11.7](#117-bugs-found-by-running-the-mapping)) |
| 3 | Add a fifth `LX*5~` / `L0…` pair and set `SE*33` | 5 packing lines, `TotalNoOfPacks` 400 |
| 4 | Break the file: delete the `SE` line | X12 Read raises an error; your error handler logs it |
| 5 | In Postman, POST the expected XML to App 2 with `<CompanyCode>` removed | App 2 returns 400 "CompanyCode is required" |
| 6 | Stop App 2 and drop a file | `HTTP:CONNECTIVITY` error, handled and logged |
| 7 | Test App 2 alone in Postman: POST the expected XML to `http://localhost:8082/api/bookings` | Confirmation XML comes back |

### 11.4 Levelling up *(40:46)*

The mentor's order for later:

```mermaid
flowchart LR
    L1["Level 1<br/>File connector<br/>(this task)"] --> L2["Level 2<br/>Queue mechanism<br/>(VM / Anypoint MQ)"] --> L3["Level 3<br/>Real SFTP connection"] --> L4["Level 4<br/>Real-time scenarios<br/>(errors, retries, volumes)"] --> L5["Page two:<br/>301 back to source"]
```

🔧 What each level adds:
- **Queue:** the listener only publishes the file to a queue; a separate flow consumes and processes it. If CargoWise is down, messages wait in the queue instead of failing.
- **SFTP:** swap `file:listener` for `sftp:listener`, keep the rest. Practise with a local SFTP server (e.g. a Docker SFTP image).
- **Real-time:** add the global error handler, a correlation ID in every log, retries with **Until Successful** on the HTTP call, sending the generated **997** back, and several bookings in one file.

### 11.5 Common problems

| Symptom | Likely cause | Fix |
|---|---|---|
| X12 Read error about identity or partner | ISA/GS IDs don't match the X12 config | Self `FLKRTT` / partner `QUINOXT` for `booking-300.edi` (or relax the identity check) |
| X12 Read error about segment count | `SE01` doesn't match the real count | Count `ST` to `SE` inclusive (31 in `booking-300.edi`) |
| ISA errors | ISA must be fixed width (106 chars including `~`) | Keep the padding spaces exactly |
| Same file processed repeatedly | No `moveToDirectory` / `autoDelete` | Set `moveToDirectory="processed"` |
| Mapping returns empty values | X12 output not under `Booking` | Wrap with `{ Booking: payload }` or edit the alias line (Step 4) |
| `Unable to call substringAfter with (Null, …)` | `B102` missing, or the path is wrong | Compare your log with `x12-read-output.json` |
| App 2 port already in use | Both apps on 8081 | Run App 2 on 8082 |

### 11.6 The mentor's mapping explained

**The idea:** a `UniversalShipment` → `Shipment` document built from three kinds of values: **mapped** from the EDI, **looked up** from a table, and **hard-coded** demo values.

```mermaid
flowchart LR
    subgraph SRC["X12 Read output"]
        B1["020_B1<br/>B101 · B102 · B103"]
        N1["080_N1_Loop[ ]"]
        R4["130_R4_Loop[ ]"]
        N9["069_N9[ ]"]
        LX["010_LX_Loop[ ].040_L0"]
        V1["090_V1 · 110_K1"]
    end
    subgraph TGT["UniversalShipment / Shipment"]
        DS["DataSource/Value<br/>CompanyCode<br/>PickUpDate"]
        OA["OrganizationAddressCollection/<br/>OrgAddress × 3"]
        PT["PortOfOrigin · PortOfLoading ·<br/>PortofDischarge · PortOfDelivery"]
        OC["OrderCollection ·<br/>ContainerNumber"]
        PK["TotalNoOfPacks · TotalWeight ·<br/>TotalVolume · PackingLine × n"]
        VS["VesselName ·<br/>GoodsDescription"]
    end
    B1 --> DS
    N1 -->|"map + Addresses lookup<br/>+ CountryCodeLists"| OA
    R4 -->|"filter by R401"| PT
    N9 --> OC
    LX -->|"sum / map"| PK
    V1 --> VS
```

**Field by field:**

| Target | Source / rule | Technique |
|---|---|---|
| `DataSource/Value` | `"SOO" ++ (number after "SHIP" in B102 × 8989)` | `substringAfter`, arithmetic, `++` |
| `BookDate` | now + 6 hours | `Periods` (`\|PT6H\|`) |
| `CompanyCode` | `B101` (carrier SCAC) | direct |
| `OrgAddress` | one per `080_N1_Loop` entry | `map` |
| ↳ `AddressType` | `N101` via `Addresses`: `FW` → SendingForwarderAddress, `CN` → ConsigneeAddress, `SH` → LocalClientAddress | **object used as a lookup table** |
| ↳ `Country/Name` | `N404` via `CountryCodeLists` (`IN` → India) | lookup table |
| ↳ `Address`, `ContactName`, `Mail` | `100_N3` / `120_G61` arrays | `reduce` (takes the last) / `[0]` (takes the first) |
| `PortOf…` (×4) | the `130_R4` whose `R401` is R / L / D / E | **`filter` then pick one** |
| `TotalNoOfPacks` / `TotalWeight` / `TotalVolume` | `sum` of `L008` / `L004` / `L006` over all packages | multi-value selector + `sum` |
| `Total…units` | `L007 == "X"` → M3; `L011 == "K"` → KG | `if / else` |
| `VesselName` | `090_V1[0].V102` | direct |
| `PickUpDate`, `EstomatedPickup` | `B103` | direct |
| `OrderNumber` | each `069_N9` → reference, sequence, type | `map` with `index + 1` |
| `ContainerNumber` | `"MIEU" ++` chars 6–10 of the N9 reference | `substring` |
| `PackingLine` | one per `010_LX_Loop` entry: qty, type, weight, volume + units | `map` + `match` |
| `Branch`, `ContainerMode`, `EntryStatus`, `PaymentMethod`, `ServiceLevel`, `WaybillNumber`, `VoyageHeightNo`, `InsuranceValue`, container `Type 40GP` | **hard-coded** demo values | literals |

**DataWeave techniques to learn from it** (each one is a likely interview question):

```dataweave
// 1. Object as a lookup table
var Addresses = { "CN": "ConsigneeAddress", "FW": "SendingForwarderAddress", "SH": "LocalClientAddress" }
Addresses["CN"]                                   // → "ConsigneeAddress"

// 2. Pick one item from a repeating segment by its qualifier
(ports filter ((p) -> p.R401 == "D"))[0]          // the port-of-discharge R4

// 3. Multi-value selector + aggregate
sum(detail."010_LX_Loop"."040_L0".L008)           // 80+80+80+80 = 320

// 4. Repeating source → repeating XML element (an array becomes repeated <OrgAddress>)
OrgAddress: heading."080_N1_Loop" map ((item, index) -> { City: item."110_N4".N401 })

// 5. Code translation with match (always add else)
item."040_L0".L011 match { case "K" -> "KG"  case "L" -> "LB"  else -> "UNKNOWN" }

// 6. Date arithmetic with dw::core::Periods
now() + |PT6H|                                    // + 6 hours
now() + |P2D|                                     // + 2 days (same as now() + days(2))
```

### 11.7 Bugs found by running the mapping

Running [x12-to-cargowise.dwl](../practice/part1/reference/x12-to-cargowise.dwl) on the reference data turned up these. All are fixed in [x12-to-cargowise-fixed.dwl](../practice/part1/reference/x12-to-cargowise-fixed.dwl) (marked `FIX n` in the file). The element names were kept identical, so the target sees the same layout.

| # | Problem | Evidence | Fix |
|---|---|---|---|
| 3 | **Discharge and delivery ports are swapped**: `PortofDischarge` reads R401 `E` (place of delivery) and `PortOfDelivery` reads `D` | Hidden in the sample because both are Houston. With `E` = Dallas, the output said discharge = Dallas | `D` → discharge, `E` → delivery (matches the mentor's own reverse mapping) |
| 5 | `<City>` written **twice** in every `OrgAddress` (the key appears twice in the object) | 6 `<City>` elements for 3 addresses | Keep one |
| 8 | Second `<WeightUnit>` in each `PackingLine` actually holds **volume** units (M3) | `<WeightUnit><Code>M3</Code>` | Rename to `<VolumeUnit>` |
| 7 | `match` without `else`: an unexpected unit code fails the whole transform | — | `else ->` branch added |
| 6 | `VesselName` keeps the leading space: `" COSCO"` | `<VesselName> COSCO</VesselName>` | `trim()` |
| 4 | `BookDate` / `DeliveryDate` print nanoseconds and a zone (`2026-10-14T05:49:28.396181138+05:30`) | — | Formatted `yyyy-MM-dd'T'HH:mm:ss` |
| 2 | `"006792" * 8989` and `"SOO" ++ number` rely on **auto-coercion** | Works, but implicit | Explicit `as Number` / `as String` |
| 1 | The same 50-character path is repeated about 30 times | — | One `booking` / `heading` / `detail` alias |

**Spelling in element names** (left unchanged, because the receiver must get exactly these names): `BookingConformation`, `BookiongConformationReference`, `GoodsVlaueCurrency`, `Descripton`, `TotalVolumeunits`, `EstomatedDelivery`, `EstomatedPickup`, `VoyageHeightNo`, `Bngalore`. In a real CargoWise integration, names must match CargoWise's schema exactly. If you build your own mock, you can correct them on both sides.

> **Interview angle:** "While testing I changed the place of delivery to a different city and found the discharge and delivery ports were swapped. It was hidden because the sample had the same port for both." That's a great real-time debugging story: test with data where similar fields have *different* values.

---

## 12. Page two: EDI going back out

### 12.1 The 301 booking confirmation back to the source

*(41:16–42:13)* After the booking is created, the business is **two-way**:

```mermaid
sequenceDiagram
    participant MC as Molson Coors
    participant Mule as Mule
    participant CW as CargoWise
    MC->>Mule: EDI 300 (booking request)
    Mule-->>MC: 997 / TA1 (file received & accepted)
    Mule->>CW: XML booking (eAdaptor, HTTPS)
    CW-->>Mule: XML confirmation
    Note over Mule: Add fields CargoWise can't provide<br/>(captured from the original 300)
    Mule->>Mule: DataWeave XML → X12 structure
    Mule->>Mule: X12 Write → EDI 301
    Mule->>MC: EDI 301 (booking confirmation)
```

Key points from the mentor:
- The source wants the answer **in EDI format only**: a **300** request gets a **301** confirmation.
- CargoWise **can't send some fields** that Molson Coors needs, so you **capture them from the original 300** and **inject** them into the 301.
- You build the EDI file with the **X12 Write** operation. "That mapping will be hard."
- **Don't lead with this in interviews.** Mention it only if they ask about the return flow.

🔧 To capture fields for later, store them when the 300 arrives, keyed by booking number (Object Store, as in [section 4](#4-design-question-the-same-transaction-id-sent-twice)), and read them back when the confirmation comes. The 997 in the diagram is the acknowledgment X12 Read already generated for you ([7.7](#77-what-x12-read-gives-you-the-real-structure)).

### 12.2 The reverse mapping: JSON → EDI 300 with X12 Write

The mentor's second reference ([json-to-x12-300.dwl](../practice/part1/reference/json-to-x12-300.dwl)) goes the **other way**: a booking in plain JSON ([booking-input.json](../practice/part1/reference/booking-input.json)) → the X12 structure → **X12 Write** → an EDI 300 file. That's exactly how `booking-300.edi` was produced, and it's the same skill you need for the 301.

**Use it for:**
1. **Generating your own test files.** Edit the JSON (new shipment ID, more packages, different ports), run it, and drop the generated `.edi` into your `inbound` folder.
2. **Practising X12 Write** before attempting the 301.

```mermaid
flowchart LR
    J["booking-input.json<br/>ShipmentID · Address[ ] ·<br/>Ports · Packages[ ]"] --> DW["Transform Message<br/>json-to-x12-300-fixed.dwl<br/>output application/java"]
    DW --> W["X12 Write<br/>004010 / 300"]
    W --> F["File Write<br/>inbound/booking-NNN.edi"]
    F -.->|"picked up by App 1"| A1["booking-from-file flow"]
```

**How the JSON maps to segments:**

| JSON | X12 key | EDI line |
|---|---|---|
| `ShipmentID`, `SCAC`, `Action Code`, `ShipDate` | `020_B1` B102, B101, B104, B103 | `B1*MUHB*SHIP006792*20230417*N~` |
| `SCAC` + fixed `SH`, `PP` | `050_Y1` | `Y1***MUHB**SH***PP~` |
| `ReferenceCollection[0].BookingReference` | `069_N9` | `N9*Reference*8687564658~` |
| `Address[]` (picked by `AddressType`) | `080_N1_Loop` ×3 (order FW, CN, SH) | `N1` / `N3` / `N4` / `G61` |
| `PlaceofReceipt`, `PortofLoading`, `PortofDischarge`, `PlaceofDelivery` | `130_R4_Loop` with R401 `R`, `L`, `D`, `E` | `R4*R**INBLR5*Bangalore~` … |
| `Packages[]` | `010_LX_Loop` (`LX` counter + `L0`) | `LX*1~` `L0****280**878*X*80*PKG**K~` |
| `VesselIMO`, `VesselName` | `090_V1` | `V1*9448815* COSCO~` |
| `NoteCollection[0]` | `110_K1` | `K1*Goods Description*Handle with care~` |

Notice the pattern: **the output is the same structure X12 Read produces** ([7.7](#77-what-x12-read-gives-you-the-real-structure)). Write takes it in; Read gives it back.

Typical flow (🔧 verify element names in Studio):

```xml
<ee:transform> <!-- json-to-x12-300-fixed.dwl --> </ee:transform>
<x12:write config-ref="X12_EDI_Config"/>
<file:write config-ref="File_Config" path="#['inbound/booking-' ++ uuid() ++ '.edi']"/>
```

**Two bugs found by running it** (fixed in [json-to-x12-300-fixed.dwl](../practice/part1/reference/json-to-x12-300-fixed.dwl)):

| # | Problem | Evidence | Fix |
|---|---|---|---|
| 1 | **Action code always `R`.** The input key is `"Action Code"` (with a space), but the code reads `payload.ActionCode`, which is always null | `"Action Code": "Create"` produced `B104 = R`, which is why the sample EDI says `B1*…*R~` instead of `N` | `payload."Action Code"` → now `N` for Create |
| 2 | **Delivery date never reaches the EDI.** The key `DTM_02` isn't an X12 element name (should be `DTM02`), and DTM02 needs a DTM01 qualifier | The generated EDI has no `DTM` line | `DTM01: "017"` (estimated delivery) + `DTM02`. ⚠️ Not tested with X12 Write here; confirm `140_DTM` is the right position key for your schema |

**Interview line:** "For outbound EDI I build the X12 structure in DataWeave with `output application/java`, using the same keys X12 Read produces, and the X12 Write operation generates the envelopes, segment counts and control numbers."

---

## 13. Interview questions and answers

### Project questions

**Q1. Explain your project.**
Use the script in [section 9.1](#91-the-project--15-minutes). Business first, then the flow: SFTP → X12 Read → JSON → DataWeave XML → eAdaptor over HTTPS.

**Q2. What is EDI? What is X12?**
EDI is electronic data interchange: a standard way for companies to exchange business documents as structured flat files. X12 is the ANSI standard used mainly in North America; each document has a number, like 300 for a booking request or 850 for a purchase order.

**Q3. What does an EDI 300 contain?**
The booking: `B1` booking number and carrier, `G61` contact, `N1/N3/N4` shipper and consignee names and addresses, `R4` ports of loading and discharge, `Y2` container requirement, `L5` cargo description and weight, all inside the `ST/SE`, `GS/GE` and `ISA/IEA` envelopes.

**Q4. Which X12 version did you use?**
004010 (4010).

**Q5. Explain ISA, GS and ST.**
`ISA/IEA` is the interchange envelope (sender, receiver, control number). `GS/GE` is the functional group (groups transactions of one type; carries the version). `ST/SE` is one transaction, for example one booking. Each header's control number must match its trailer.

**Q6. How do you convert EDI to JSON in MuleSoft?**
With the X12 connector's **Read** operation, configured with the 004010 300 schema. It parses the file into a structured object, and then DataWeave maps it to JSON.

**Q7. Why convert to JSON first and not straight to XML?**
JSON is a clean, canonical model of the booking. It's easy to log, validate and reuse, and if a second target is added later, you map from the same JSON. (You *can* map straight from the X12 output to XML; the two-step approach is the mentor's flow.)

**Q8. What does CargoWise accept?**
XML in specific module formats, received through its **eAdaptor** over HTTPS.

**Q9. Why SFTP and not AS2?**
SFTP is what the client used for this integration: they drop files, and we pick them up. AS2 is a B2B protocol over HTTP that uses certificates for signing and encryption, plus receipts (MDNs). It's common in EDI, but we didn't need it here.

**Q10. How do you avoid processing the same file twice?**
The SFTP/File listener moves or deletes each file after pick-up (`moveToDirectory` / `autoDelete`). For extra safety, an idempotency check on the booking number (Idempotent Message Validator with an Object Store).

**Q11. What happens if CargoWise is down?**
The HTTP Request fails with a connectivity error, and the global error handler logs it, creates a ticket with the correlation ID and file name, and notifies. The file can be replayed. Better still: retry with **Until Successful**, or put a queue in between.

**Q12. What if the EDI file is invalid?**
X12 Read raises a parse/validation error, and the global error handler logs it and notifies the source so they can resend a corrected file. Bad data isn't retried automatically.

**Q13. How do you send a confirmation back?**
CargoWise's XML confirmation is mapped back to an X12 structure, extra fields captured from the original 300 are added, and **X12 Write** generates an **EDI 301**, which is sent back to Molson Coors.

### MuleSoft concept questions

**Q14. Why MuleSoft?**
It's an integration layer: reusable APIs instead of point-to-point connections. New projects call existing endpoints instead of re-implementing database or system access *(5:37)*.

**Q15. What is API-led connectivity?**
Three layers of APIs: **System** APIs unlock one system each, **Process** APIs hold business logic and orchestration, **Experience** APIs shape data for each consumer. Each layer is reusable.

**Q16. Same transaction ID sent twice: what do you do?**
Use the **Idempotent Message Validator** with a persistent Object Store keyed on the transaction ID. If duplicates must update rather than be rejected: `os:contains` plus a Choice router, then `os:store` *(section 4)*.

**Q17. Set Variable vs Set Payload?**
Set Payload replaces the message body. Set Variable stores a value under a name (`vars.name`) that stays available through the rest of the flow, without touching the payload.

**Q18. On Error Propagate vs On Error Continue?**
Propagate handles the error and re-throws it, so the caller sees a failure. Continue handles it and lets the flow finish as a success, using the error handler's result as the response.

**Q19. How do you secure your APIs?**
**Client ID Enforcement** in API Manager, HTTPS/TLS, and **Secure Properties** with AES encryption for credentials, with the key supplied at deploy time.

**Q20. What is a correlation ID?**
A unique ID for one message's journey. It's included in every log line and ticket, so you can trace one booking end to end.

**Q21. How do you deploy?**
Code in **Bitbucket**, with **Bitbucket Pipelines** running Maven builds (plus MUnit tests) and deploying with the mule-maven-plugin to **CloudHub 2.0**, per environment.

**Q22. File List vs File Read?**
**List** returns the files in a directory (with attributes like `fileName`). **Read** returns the content of one file at a given path. In the duplicate-check design, List checks whether `<id>.json` exists.

**Q23. What is Object Store?**
A key–value store built into Mule for small state: idempotency keys, watermarks, cached tokens. A persistent Object Store survives restarts; on CloudHub, Object Store v2 is shared across workers.

### From the mentor's reference files

**Q24. What does the X12 Read output look like? How are the keys named?**
`TransactionSets.v004010."300"[ ]`, with `Interchange`, `Group`, `Heading`, `Detail` and `Summary` in each. Segment keys are position + segment ID (`020_B1`, `110_N4`). Loops end in `_Loop` (`080_N1_Loop`). Repeatable segments are arrays. Elements are segment ID + position (`B102`). Dates and numbers come out already typed.

**Q25. What are 997 and TA1?**
Acknowledgments. **TA1** confirms the interchange envelope (ISA/IEA) arrived and is valid. **997** (functional acknowledgment) confirms the functional group was accepted (`AK901 = A`). X12 Read generates both automatically (`InterchangeAcksGenerated`, `FunctionalAcksGenerated`), and you send them back to the partner with X12 Write.

**Q26. What do the R4 qualifiers mean?**
`R401`: **R** place of receipt, **L** port of loading, **D** port of discharge, **E** place of delivery. In DataWeave, pick one with `(ports filter ($.R401 == "D"))[0]`.

**Q27. How do you map repeating EDI segments (N1 loop, LX loop) to XML?**
`map` over the loop array. Each array item becomes a repeated XML element, e.g. `OrgAddress: heading."080_N1_Loop" map (...)` gives three `<OrgAddress>` elements. For totals, use a multi-value selector with `sum`: `sum(detail."010_LX_Loop"."040_L0".L004)`.

**Q28. How do you translate codes (FW / CN / SH, country codes)?**
Keep an **object as a lookup table**, e.g. `Addresses = { "FW": "SendingForwarderAddress", … }` and read it with `Addresses[item."080_N1".N101]`. For bigger tables, move them into a DataWeave module, or into a properties or CSV file loaded with `readUrl`.

**Q29. Tell me about a bug you found in a mapping.**
"The port of discharge and place of delivery were swapped: the mapping read R4 qualifier E for discharge. Our test file had Houston for both, so it looked right. I caught it by testing with a different delivery city, fixed the qualifiers, and since then I always test with data where similar fields have different values."

**Q30. How do you create outbound EDI?**
Build the X12 structure in DataWeave (`output application/java`) with the same keys X12 Read produces, then **X12 Write** generates the EDI text, including envelopes, segment counts and control numbers. Watch the input key names: a JSON key like `"Action Code"` needs quotes, or the value silently comes out null.

---

## 14. Glossary

| Term | Meaning |
|---|---|
| **AS2** | Applicability Statement 2: a secure B2B protocol over HTTP using certificates and receipts (MDNs) |
| **CargoWise** | Logistics / shipment management software; the target system |
| **eAdaptor** | CargoWise's integration service, which accepts XML over HTTPS |
| **Consignee** | The party receiving the goods (`N1*CN`) |
| **Shipper** | The party sending the goods (`N1*SH`) |
| **Port of loading / discharge** | Where the container is loaded (`R4*L`) / unloaded (`R4*D`) |
| **40G0** | Container type code: 40 ft general purpose |
| **EDI 300 / 301 / 303 / 304** | Booking request / booking confirmation / cancellation / shipping instructions |
| **X12 Read / Write** | MuleSoft X12 connector operations: parse EDI → data / generate data → EDI |
| **DataWeave** | MuleSoft's transformation language (Transform Message) |
| **Object Store** | Mule's built-in key–value store |
| **Client ID Enforcement** | API Manager policy requiring a valid client_id and client_secret |
| **Secure Properties** | Encrypted property values, e.g. with AES |
| **CloudHub 2.0** | MuleSoft's managed cloud runtime |
| **CTC** | Cost to company: total annual salary package |
| **JD** | Job description |
| **SCAC** | Standard Carrier Alpha Code: a carrier's 2–4 letter ID (`MUHB` in `B101`) |
| **IMO number** | A vessel's permanent ID (`9448815` in `V101`) |
| **UniversalShipment** | The CargoWise XML document the mentor's mapping produces |
| **997 / TA1** | Functional acknowledgment / interchange acknowledgment, generated by X12 Read |
| **Place of receipt / delivery** | Where the carrier takes the goods (`R4*R`) / hands them over (`R4*E`) |
| **Fluence** | The trading partner's ID in the mentor's sample (`ISA06`) |

---

## 15. One-page revision sheet

**Business:** Molson Coors (beverage company, **source**) books shipments in **CargoWise** (shipment management tool, **target**). Bookings used to be manual (email → operator → form); we **automated** them with MuleSoft.

**Flow:**
`EDI 300 on SFTP` → **SFTP listener** → **X12 Read** (004010/300) → **JSON** → **DataWeave** → **CargoWise XML** → **HTTP Request (HTTPS)** → **eAdaptor** → booking created.

**EDI 300:** `B1` booking no. · `G61` contact · `N1/N3/N4` shipper (SH) and consignee (CN) · `R4` ports (L loading, D discharge) · `Y2` container · `L5` cargo · envelopes `ISA/GS/ST … SE/GE/IEA` with matching control numbers.

**Script order:** Intro → Experience → Certification → **Project** → Connections (SFTP in, HTTPS/eAdaptor out) → Security (Client ID Enforcement, AES Secure Properties) → Errors (global handler: log, ticket with correlation ID, retry, notify) → Deploy (Bitbucket → Pipelines → CloudHub 2.0).

**X12 keys:** `Heading."020_B1".B102` booking ID · `"080_N1_Loop"[ ]` parties · `"130_R4_Loop"[ ]."130_R4"` ports (R receipt · L loading · D discharge · E delivery) · `Detail."010_LX_Loop"[ ]."040_L0"` packages · X12 Read also gives you a **997 / TA1**.

**Mentor's mapping:** X12 output → `UniversalShipment` XML with `map` (addresses, packing lines), `filter` (ports), `sum` (totals) and lookup objects (address types, countries). Use the **fixed** copy: discharge/delivery swap, duplicate City, WeightUnit/VolumeUnit.

**Duplicate ID answer:** Idempotent Message Validator plus a persistent Object Store; to update duplicates, `os:contains` → Choice → `os:store`.

**Practice task:** File listener → X12 Read → JSON → XML → POST to **your own mock CargoWise API** (validates, returns a confirmation built from the request). Then: queue → real SFTP → real-time handling → **301 back with X12 Write**.

**Golden rule:** *page one only, simple and clear.*
