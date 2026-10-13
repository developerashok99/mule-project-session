# Project Session Part 1 — Cleaned Transcript

A one-to-one mentoring call on Google Meet, about 44 minutes, spoken mostly in Telugu with English technical terms. The mentor plans the student's job search, checks some MuleSoft basics, asks a design question, then builds a sample project explanation on screen (**Molson Coors → CargoWise booking integration**) and sets a practice task.

**How this was made.** Whisper `medium` (run locally) translated the Telugu audio to English. A few stretches it skipped (0:20–1:30, 2:06–4:28, 16:38–19:40, 21:02–21:48, 28:30–29:22, 32:02–33:04, 41:16–41:51) were run again with Whisper `large-v3`. The text was then cleaned using the on-screen notes: misheard terms were corrected ("Moulson Coors / Malsan Kursa" → Molson Coors, "Cargo Voice / CargoVisual / Cargavise" → CargoWise, "EDA / EDF file" → EDI file, "extra read" → X12 Read, "STTPS" → HTTPS, "EARaptor" → eAdaptor, "cloudop 2.0" → CloudHub 2.0, "CACD" → CI/CD, "3015" → 301, "Fluent/Fluence" → Fluence, confirmed by the sender ID `FLUENCE` in the mentor's reference X12 file). Repetition loops and side chatter were removed. Nothing was added; anything that can't be recovered is marked **[unclear]**, and *[screen: …]* lines show what was on the shared screen. Speakers are **Mentor** and **Student**.

Raw output: [part1-raw.txt](part1-raw.txt) · [part1-raw-gaps-large-v3.txt](part1-raw-gaps-large-v3.txt) · Slides: [slides/part1](../slides/part1/README.md)

## Contents

1. [Job-search plan and recruiter calls](#1-job-search-plan-and-recruiter-calls) — 0:00
2. [MuleSoft basics: architecture and why MuleSoft](#2-mulesoft-basics-architecture-and-why-mulesoft) — 4:59
3. [Design question: the same transaction ID sent twice](#3-design-question-the-same-transaction-id-sent-twice) — 10:23
4. [Why you present one simple project](#4-why-you-present-one-simple-project) — 16:38
5. [The project: Molson Coors → CargoWise bookings](#5-the-project-molson-coors--cargowise-bookings) — 19:21
6. [How to tell this project in an interview](#6-how-to-tell-this-project-in-an-interview) — 33:01
7. [Practice task](#7-practice-task) — 38:19

---

## 1. Job-search plan and recruiter calls

**[0:00] Mentor:** Next week, on the 17th, I'm going to Bangalore. I'll be back on the 24th. From the 26th we can start preparing the résumé and making your profile.

**[0:19] Student:** I don't mind if you ask me to do it now. I'm okay with that.

**[0:24] Mentor:** Once the profile is up this week, it will take at least a week before you start getting calls. Do you have an idea how to talk on those calls?

**[0:34] Student:** Yeah.

**[0:36] Mentor:** Say an HR person calls and asks about you. Keep three things in mind. First, as a developer, what are your roles and responsibilities? Some people ask exactly that. They ask some default questions based on the JD: *what do you do as a MuleSoft developer?* There are points you should say that match the JD, for example the API-led connectivity approach, Choice router, connectors and so on. Once they ask, you can also explain the roles and responsibilities given in the description.

**[1:27]** Then they'll ask about your experience: how much experience you have, your relevant experience in MuleSoft, your current package and expected CTC (current CTC, expected CTC). After that they'll ask about your notice period and your availability, and note all of it down.

**[2:06]** For example, if they have had the same opening for a month **[unclear]**, they will go for you immediately.

**[2:28]** The normal first calls, the initial call, will you handle it, or shall I handle it?

**[2:36] Student:** No, I will handle it.

**[2:38] Mentor:** Okay. Then note down which company each call is from. Keep a list of the calls from every company, and update the status of each company daily.

**[4:15]** You know this process, right? **[4:25]** They will process your résumé. If you are shortlisted they will call you and schedule an interview based on your availability. We attend the interview. If there is another round, they give feedback and then the next round. If there is a client round, there will be a client round. Then they ask for your documents, and then they release the offer letter. That is the process. That's the basic part.

## 2. MuleSoft basics: architecture and why MuleSoft

**[5:01] Mentor:** Now for MuleSoft. Do you know these architectures? What is the payload content? What are the different styles of architecture in MuleSoft?

**[5:17] Student:** MVC architecture: model, view, controller. The business logic or code is separated.

**[5:24] Mentor:** Yeah, okay, basic concept. Why do we have architecture at all?

**[5:33] Student:** So we can easily debug.

**[5:37] Mentor:** Basically, why MuleSoft? MuleSoft is an integration layer. For example, say your company has a dedicated system, a SQL database. Every time you build an integration (create an account, get user information, delete it, update it, insert information from somewhere else), you have to connect to the database. If you are building an API to create a user account, what do you do? You build the SQL connection again and write the insert queries again. That one dedicated system is involved in every project.

**[6:54]** So instead of calling the database directly, they call another API. If you want to insert data, instead of configuring the database you call a POST endpoint and send the data. If you want information, you query it through the API. Based on a set of requirements and instructions, that API already exposes such an endpoint, and every other project uses the same endpoint to get the information. Whatever the database can do is available through it. **[8:17]** So you don't need to rebuild anything; you only need the API details, and those were built in the past.

**[8:31]** In terms of architecture, *I* have worked mainly on the **API-led connectivity** architecture. There is also an integration pattern that works as **extraction, transformation and loading (ETL)**.

**[8:59]** Our base is workflows, which is very different. We build any number of workflows, one per customer, so a new customer gets a new workflow, and their integration runs on it. **[unclear: "using this QAPS"]**

**[9:32]** There are many different integration patterns. Some do it in a single-layer architecture; some use the API-led connectivity approach. For this interview, preparing that much is enough.

## 3. Design question: the same transaction ID sent twice

**[10:23] Mentor:** A question for you. I'm asking you to build an integration. Requirement: a source system sends a JSON payload containing a unique transaction ID. You store it, then you call a target system, and that completes. Next time, the user sends the same transaction with the same ID. What do you do this time?

**[12:27] Student:** First we design an API with the POST method. That API inserts the unique transaction ID into the DB, then calls the target system. The second time, when the same transaction ID comes, we first check whether it is already in the DB. If it is not, we again use POST and insert it. If it is, we use an update method (update, PATCH, PUT or something), update the record and send it to the target.

**[13:11] Mentor:** Okay. How would you do that in MuleSoft? Which connectors?

**[13:17] Student:** I don't know; I haven't worked on DB yet. It's the DB connectors, right?

**[13:25] Mentor:** It isn't a DB. It's the Object Store idea, to store it temporarily. Okay, say it's a normal local file system. How will you do it?

**[13:43] Student:** With the file system, read the file, get the data, extract it… **[unclear]** …as JSON, then check whether it is an already-existing payload or a new payload.

**[14:17] Mentor:** Yes, you understand the concept, but how do you do it in MuleSoft? First you get a record and you have to store it somewhere, like the input payload. How do you store it?

**[14:45] Student:** Store the data in the flow in a variable, with Set Variable. The variable is stored under a key–value name.

**[15:41] Mentor:** So for this integration: first store the ID, then do a file read. File Read is the operation that reads files from a path. You know they store the files under the same ID. To check whether that ID already exists, use the **List** operation; it gives you all the file names. Then filter the list by file name. If the record already exists, you update it.

**[16:19]** **[unclear: short exchange; the student had not done this before]**

## 4. Why you present one simple project

**[16:38] Mentor:** You haven't done a project yet, right? So what will your project be? Now I'll tell you what your project should look like. Our work is based on workflows, so I'll give you one workflow for your project. One workflow per project.

**[17:05]** I could explain the whole ETL structure, but even the interviewer won't follow it; they'll get confused. *What is that? How did you do that?* There will be cross-questions. So keep it to a single, simple project so they understand the business.

**[17:24]** This description is very important. In your interview you'll say it in the first 5 to 10 minutes. It's the intro that grabs their attention, so say it realistically. You can use my words or improve on them; it's up to you.

**[18:30]** Okay, project opening. I'll show you a small sample project based on an actual project. **[19:05]** Let's take **Molson Coors**.

*[screen: 19:21 — the mentor starts sharing their screen]*

## 5. The project: Molson Coors → CargoWise bookings

**[19:56] Mentor:** What is the name of the company? Molson Coors. This is a cargo integration project, a US-based project. What is Molson Coors? A multinational drink and beverage company. Brands… okay, you'd need to know them in case they ask that kind of question. It's basically a beer company.

*[screen: 22:20 — Notepad++, line 1: `MOLSON COORS (WHAT IS THIS COMPANY)`]* → [slide 01](../slides/part1/01-notes-start.jpg)

**[20:52]** They ship to very different countries, so they need a logistics partner. For that, they want to integrate with **CargoWise**, a shipment management tool.

**[21:55]** So here's the first point: what is this company? That is the **source**. What is the **target**? CargoWise. What is CargoWise? A **shipment management tool**; it manages logistics.

*[screen: 25:42 — Google: Molson Coors Beverage Company, formed by the 2005 merger of Molson (Canada) and Coors (US), HQ Chicago, 5th largest brewer]* → [slide 02](../slides/part1/02-molson-coors-google.jpg)

**[23:20]** So the integration is: Molson Coors is going to do its logistics through CargoWise. The first integration is **bookings**. Molson Coors uses its system, CargoWise is a different system, so they need an integration team to connect them. That's why they chose our company: our company uses MuleSoft, and that's why we are here.

**[24:11]** So we have to create the bookings in CargoWise. How was it done before? Manually: they would call or email the operators, the operators would read the email and enter the booking in the shipment management tool. It's like a form, a booking screen; all the information is entered and the booking is created. That's the manual way. **Here, we automated it: whenever we get a booking, we create it in CargoWise.**

**[25:04]** From Molson Coors we receive **EDI 300 files**. EDI means *electronic data interchange*. They are in a flat-file, structured format. I'll tell you more about EDI later. Let's look at a sample; I'll give you a real-time sample as well.

*[screen: 26:08 — Google: key segments in an EDI 300 file, and related transactions 301 booking confirmation, 303 cancellation, 304 shipping instructions]* → [slide 03](../slides/part1/03-edi300-key-segments.jpg)

**[25:45]** There are different versions of these files; we use version **4010** (`004010`). This is how it looks. **[26:28]** All the integrations at Molson Coors are based on these files.

*[screen: 26:33 — a sample EDI 300 file pasted into Notepad++]* → [slide 04](../slides/part1/04-edi300-sample-trailer.jpg), [slide 07](../slides/part1/07-edi300-sample-body.jpg)

**[26:35]** This is called the **ISA segment**; you can learn the EDI details later. Here the **booking number** is there, the **contact information**, the **addresses**, the **route details**, like where the loading happens and where the unloading happens. If I want a type of container, say I need a 40 ft one, a 40-foot general-purpose container, that's here. In **L5**, what is he sending? **Electronic components**, gross weight **8504**. I know these EDI files aren't easy to understand yet, but later you will understand them. So this is how one booking file looks.

*[screen: 27:32 — notes: `CARGOWISE (SHIPMENT MANAGEMENT TOOL)` / `BOOKINGS --> 300 EDI FILE`]* → [slide 05](../slides/part1/05-notes-bookings-300.jpg)

**[27:32]** There are different ways to receive this file. One is an **AS2** connection. We have the HTTP protocol, and AS2 is also a protocol for transferring to web services. AS2 is a secure protocol with partners on both sides (client and trading partner); you have to provide certificates and everything.

**[28:14]** From an interview point of view, AS2 is a foundation topic, but there will be a lot of questions on it. AS2 is a bit difficult, and the interviewer may not know AS2 either. So say you are using an **SFTP** connection: they put the file there, and you pick the file up.

*[screen: 29:39 — notes: `sftp connection --> file pick from sftp` / `x12 read --> 300 EDI FILE extract`]* → [slide 06](../slides/part1/06-notes-sftp-x12.jpg)

**[28:52]** So what is **X12 Read**? They are sending an EDI file, right? To extract that file, X12 is a connector in MuleSoft. You use it to extract the EDI 300 file. The connector has the default schemas defined in it, so it parses against the schemas and extracts the data. Then you can use it as JSON or anything else. So you extract it into JSON, and then you start mapping. Now you have your JSON.

**[30:08]** You have your JSON, and you'd send it to CargoWise from JSON, right? But CargoWise only accepts **XML, in specific modules**. So you have to transform it to XML in that specific module's format. Transform.

*[screen: 31:26 — notes: `extract to Json` / `json -- xml transform --> transform to cargowise booking` / `sending xml to cargowise`]* → [slide 08](../slides/part1/08-notes-json-xml.jpg)

**[31:17]** The next step is to send it to the target, to CargoWise, through one of its adapter services, the **eAdaptor**. The protocol is **HTTPS**. Via an HTTPS request you send the file to them.

**[32:02]** This is your complete business: one page of business. There are extensions to it, but if you put it in a single layer, this is it. That's how a real-time business works.

**[32:37]** So, what is your source system here?

**[32:42] Student:** The source system is bookings, right?

**[32:45] Mentor:** Bookings means…? What is this? *(points at line 1)*

**[32:50] Student:** Molson Coors.

**[32:58] Mentor:** So Molson Coors is the source system, and what is the target? **[unclear]**

## 6. How to tell this project in an interview

**[33:03] Mentor:** If you want me to tell this project, I'd tell it like this. First there's an intro. Then your experience: your overall experience in MuleSoft. Then any certification you've done; you can add a point like *in my previous organization I got a certificate*, something like that. Then: *I will walk you through my latest project.* Then you start on this integration:

> **[33:51]** "Let me talk about my last project. It was the **Molson Coors and CargoWise integration** project. Molson Coors was our **source system**; it is a beverages company. CargoWise is the **target system**; it is a shipment management tool.
>
> From Molson Coors we receive the data in **EDI 300 format**, and similarly we get 304 and others. These files contain **booking information**: booking number, addresses, contact information, port information. We get all of this from Molson Coors in EDI 300 format.
>
> We extract that EDI 300 file into **JSON** using the **X12 Read** connector. Then we transform it into **XML** using DataWeave logic, according to the target system, CargoWise. Then we send the files to CargoWise via the **eAdaptor**, over the HTTP protocol. That is how we post the files to CargoWise. And this is our business."

**[35:06] Mentor:** After that you talk about **connections**:

> "Coming to connections: we built a few APIs for **Fluence**. They work over an **SFTP** connection: through SFTP we receive the files from Fluence, and we send files to CargoWise via HTTP using the **eAdaptor**."

**[35:40]** Then you talk about **security**:

> "We secure the APIs internally using the **Client ID Enforcement** policy, and we secure sensitive information in the property files using encryption algorithms like **AES**." **[unclear: "entire security, E2 points"]**

**[36:08]** Then **error handling**. *How are you handling errors in your flows?*

> "Coming to error handling: we have **common flows**, and in them a **global error handler**. Whenever there is an issue in a flow, it goes straight to the global error handler. From there we process the error, store the error message and **log it in a proper format**. We also **create a ticket** **[unclear: ticketing tool]** with the **correlation ID**, the error message and some properties so we can **retry the same file**. And we trigger **notifications** to the source and target recipients."

**[37:09]** That's how you handle errors and alert people properly. That part is done too.

**[37:21]** The next step: *how are you building and deploying your project?*

> "Our code repository was **Bitbucket**, and we deploy our project to **CloudHub 2.0** through **CI/CD Bitbucket pipelines**."

**[37:49]** This is a standard point **[unclear]** because I'm working on Bitbucket Pipelines myself. From there, they'll start asking you a few questions.

## 7. Practice task

*[screen: 39:03 — `sftp connection` changed to `file connection --> file pick`]* → [slide 09](../slides/part1/09-notes-file-connection.jpg)

**[38:19] Mentor:** Here's what I'm giving you. Instead of SFTP, just use a **File** connection. Take some EDI 300 file samples and place them in a folder your File connector watches. Whenever you drop a file in, the flow runs and picks it up. Use the **X12 Read** connector; it reads the file. Add a **Transform Message** to convert it into JSON. I'll give you a sample XML file, or maybe a mapping sheet; I'll send you some information. Then you transform it to that XML.

**[39:13]** In parallel, create **another API**, the second API, that receives this request. What should the second API do? It takes an **XML payload**, and from that XML payload you build a **response using some properties from the payload**. It's not completely dummy: you received a booking, so you accept the booking and respond with a **confirmation message**. You can put some validations in your mapping that accept this XML and send a response. Deploy this one as an application and keep it running.

**[40:19]** Once that's done, call it from the first flow: after your XML is ready, you send the XML to "CargoWise" (your second API). That's how you complete this integration.

*[screen: 41:20 — final line: `sending xml to cargowise -> eAdaptor (https) http request`]* → [slide 10](../slides/part1/10-notes-final-flow.jpg)

**[40:46]** First we'll do it with the File connection, then we'll take it to the next level: a queue mechanism, or a real SFTP connection, then real-time scenarios. When you've done this much, you'll have a complete idea of how you extract and which parameters you use in the X12 Read.

**[41:16]** After this, the next part sends from CargoWise **back to the source system**, converting from XML back to EDI. It's a two-way business. When you send back to them, they need a few fields that CargoWise can't send you, so you have to capture those fields and inject them when you send back to the source. They need it in EDI format only: if this is a booking and they send a **300**, you have to send a **301** for booking confirmation. You have to create an EDI file, and that mapping will be hard. We'll do that with the **X12 Write** component.

**[42:13]** When you complete this page, we'll go to page two. But in your interview explanation, go with page one only. If you say too much, the interviewer won't follow. It should be simple and clear.

**[42:42]** I think this is enough. We'll connect again in the afternoon.

**[42:49] Student:** Okay.
