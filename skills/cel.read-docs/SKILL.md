---
name: cel.read-docs
description: Reads all markdown documentation files in the current directory and subdirectories, including referenced diagrams and images, providing context and a simple summary for the user about the local project or environment.
---

# Read Docs

This skill performs a complete read of all markdown and referenced documentation for the purpose of loading and understanding project context.

## Workflow Steps

This skill executes the following steps in order:

### 1. Search for root readme
Search the root working directory for a readme file in common formats:
- readme.md (most common)
- readme.txt
- README.md, README.txt (case variations)
- Other readme variants (readme.markdown, etc.)

### 2. Search for all markdown files
Search across the root working directory and all subdirectories for all .md (markdown) files.
Compile a list of all markdown documents, with the readme at the top of the list.

### 3. Read all markdown documents
Iterate through each markdown file from the list one by one, and read the contents into context.
For each markdown file:
- Read the full content including any embedded code blocks (especially mermaid diagrams)
- Identify and follow any reference links to non-markdown files within the project, such as:
  - Diagram files (.mmd, .mermaid, .svg, .png, .jpg for diagrams)
  - Image files referenced in the documentation
  - Other document formats explicitly linked (e.g., .txt, .pdf references)
- Read these referenced files for extended context
- Do NOT read arbitrary text files that are not referenced from documentation

### 4. Provide Summary
Once all documents have been read, summarize all aspects of the full context into one simple and concise summary, and output this formatted nicely for the user.

## How to Use This Skill

### Option 1: Using the Slash Command
```
/read docs
```

### Option 2: Calling as a Named Skill
```
skill: "read docs"
```

## When to Use This Skill

Use the read docs skill when you need to:
- Build an initial context of the project
- The user asks you to read, understand, explore, summarise, explain, or build context of this project

## Important Notes

- **Readme search**: Look for readme files in common formats (md, txt, markdown) but prioritize .md
- **Markdown focus**: Primary document search targets only markdown (.md) files
- **Follow references only**: Read non-markdown files ONLY if they are explicitly referenced/linked from markdown documents
- **Include diagrams**: Pay special attention to mermaid diagrams (embedded or linked) and other visual documentation
- **Scope limitation**: Do NOT read arbitrary text files, code files, or configuration files unless referenced from documentation
- **Context only**: Do NOT review the quality, accuracy, or value of the documents - ONLY read contents for building context
- **Concise summary**: Output should be no more than 2-3 sentences with a very high level overview of the project
- **Autonomous execution**: This skill executes all steps automatically without asking for permission - this is intentional behavior to enable efficient multi-step documentation reading workflows across subdirectories

