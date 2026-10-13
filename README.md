# MuleSoft Project Session Notes

Transcripts, slides and diagrams from one-to-one MuleSoft project mentoring sessions (spoken in Telugu, written up in English). They are for practising how to explain a real-time integration project in interviews.

## Part 1 — Molson Coors → CargoWise booking integration

- **[Super-detailed notes](notes/part1-super-detailed.md)**: the business, the EDI 300 line by line, the flow step by step, the interview script, connections/security/error handling/CI-CD, the full practice task with Mule XML and DataWeave, the mentor's X12 → CargoWise mapping explained field by field with the bugs found by running it, the 301 return flow and JSON → EDI with X12 Write, 30 interview Q&As and a one-page revision sheet
- [Practice reference files](practice/part1/reference/): the mentor's sample EDI 300, its X12 Read output, and both DataWeave mappings (as sent, plus tested corrected copies)
- [Cleaned transcript](transcripts/part1.md): job-search plan, MuleSoft basics, a duplicate-transaction design question, the project walkthrough, a word-for-word interview script and the practice task
- [Slides and diagram](slides/part1/README.md): screens from the session, the integration flow diagram, and the sample EDI 300 file explained line by line
- Raw Whisper output: [part1-raw.txt](transcripts/part1-raw.txt) · [part1-raw-gaps-large-v3.txt](transcripts/part1-raw-gaps-large-v3.txt)

```mermaid
flowchart LR
    MC["Molson Coors<br/>(source)"] -->|"EDI 300 via SFTP"| X12["X12 Read<br/>EDI → JSON"]
    X12 --> DW["DataWeave<br/>JSON → XML"]
    DW -->|"HTTPS"| EA["eAdaptor"] --> CW["CargoWise<br/>(target)"]
```

## How these were made

1. **Transcript:** Whisper (`medium`, run locally) translated the Telugu audio to English. Spans it skipped were re-run with `large-v3`.
2. **Slides:** ffmpeg scene detection extracted frames, near-duplicates were removed, and the meaningful screen-share frames were picked and cropped to the shared window.
3. **Cleanup:** Claude corrected misheard terms using the on-screen text, removed repetition loops, and added punctuation, speakers and screen markers. Nothing was invented; unrecoverable parts are marked **[unclear]**.
