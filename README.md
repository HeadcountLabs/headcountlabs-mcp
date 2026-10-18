<p align="center">
  <a href="https://headcountlabs.com/mcp/"><img src="icon.png" alt="Headcount Labs" width="96" height="96"></a>
</p>

# Headcount Labs MCP server

Job postings for AI agents. Headcount Labs is a hosted [Model Context Protocol](https://modelcontextprotocol.io)
server that lets Claude, ChatGPT, Codex, Cursor, VS Code and other MCP clients search, count and read open jobs from
employers' own career sites and the hiring platforms they use (Workday, Greenhouse, Lever, iCIMS, SmartRecruiters and
others). Copies of the same opening are merged into one job, and every job keeps the link to the original posting.

There is nothing to install or run. This repository holds the connection instructions, client examples and the
official MCP Registry entry ([`server.json`](server.json), name `com.headcountlabs/jobs`). The server itself is hosted.

| Endpoint | Sign-in | Tools |
| --- | --- | --- |
| `https://api.headcountlabs.com/mcp/public` | None | 6 read-only tools; one search shows up to 100 matching jobs |
| `https://api.headcountlabs.com/mcp` | OAuth 2.1 (PKCE, dynamic client registration) or an API key as a bearer token | 26 tools, including exports, the company registry, the job change feed and usage |

Both use the Streamable HTTP transport.

**Pricing.** Every organization gets 100,000 records free each calendar month (UTC), with no card. After that, records
cost a flat $0.01 per 1,000. Counts, market insights, field lookups and doc searches are free.
See [headcountlabs.com/pricing](https://headcountlabs.com/pricing/).

## Try it without an account

Add the public endpoint to any MCP client. In Claude Code:

```bash
claude mcp add --transport http headcountlabs-public https://api.headcountlabs.com/mcp/public
```

Or call it directly. This counts every open job in the catalog:

```bash
curl -s https://api.headcountlabs.com/mcp/public \
  -H "content-type: application/json" -H "accept: application/json, text/event-stream" \
  -d '{"jsonrpc":"2.0","id":1,"method":"tools/call","params":{"name":"count_jobs","arguments":{}}}'
```

## Connect with an account

Claude Code (then run `/mcp` and choose Authenticate):

```bash
claude mcp add --transport http headcountlabs https://api.headcountlabs.com/mcp
```

Or install the [Claude Code plugin](https://github.com/HeadcountLabs/claude-plugin), which adds the server and a
job-search skill:

```
/plugin install headcount-labs --marketplace HeadcountLabs/claude-plugin
```

Codex:

```bash
codex mcp add headcountlabs --url https://api.headcountlabs.com/mcp
codex mcp login headcountlabs
```

Cursor, Windsurf and other clients that read `mcp.json`: [examples/mcp.json](examples/mcp.json).
VS Code: [examples/vscode-mcp.json](examples/vscode-mcp.json).
claude.ai and Claude Desktop: add a custom connector with the endpoint URL.
ChatGPT: [headcountlabs.com/mcp/chatgpt](https://headcountlabs.com/mcp/chatgpt/). Grok:
[headcountlabs.com/mcp/grok](https://headcountlabs.com/mcp/grok/).
Clients without remote server support: run `npx mcp-remote https://api.headcountlabs.com/mcp` as the server command.

## Tools

The public endpoint serves the first six tools in this table. The signed-in endpoint serves all of them. The full
reference, with scopes and limits, is at [headcountlabs.com/docs/mcp-tools](https://headcountlabs.com/docs/mcp-tools/).

| Tool | What it does | Uses records |
| --- | --- | --- |
| `search_jobs` | Finds jobs by title, keywords, company, city, state, country, work arrangement, pay and dates. Signed in, `deliver_file: true` writes up to 5,000 jobs to a file. | Yes |
| `count_jobs` | Counts the jobs that match a set of filters, optionally grouped by employer. | No |
| `get_job` | Reads one job with every linked posting and its source links. | Yes |
| `market_insights` | Pay, top employers, remote share, metros, jobs by state and more, from a dated snapshot. | No |
| `list_fields` | Finds the filters and job fields that match your words, such as "pay" or "remote". | No |
| `search_docs` | Returns the best-matching sections of the Headcount Labs docs. | No |
| `read_file` | Pages through a file that `search_jobs` delivered, for 24 hours. | No |
| `verify_jobs` | Re-opens a random sample of original postings and checks link, status, title, employer, location and pay. | Sampled jobs |
| `compare_sources` | Matches your own job list against Headcount Labs, row by row. | Matched jobs |
| `search_jobs_json`, `search_jobs_dsl` | The same search with a JSON body or Elasticsearch-style clauses. | Yes |
| `list_job_changes` | New, changed and closed jobs since a time or cursor. | Yes |
| `list_companies`, `search_companies`, `get_company`, `list_company_jobs` | The company registry and each company's jobs (needs the `companies:read` scope). | Jobs only |
| `create_job_export`, `list_job_exports`, `get_job_export`, `read_job_export_file` | Asynchronous exports of up to 100,000 jobs. | Completed exports |
| `get_usage`, `get_overage`, `get_usage_requests`, `get_usage_analytics` | Your plan, records used and left, overage status and request reports. | No |
| `set_confirmation_level`, `set_overage` | How large a search may be before the agent must ask you, and overage billing on or off. Agents change them only when you ask. | No |

Every tool carries a `title` and `readOnlyHint` or `destructiveHint` annotations. The tools read job data. They can't
apply to jobs or contact employers.

## Example prompts

- "How many data engineer jobs are open in Germany right now?"
- "Find 5 remote software engineer jobs in the US posted in the last week, with pay and apply links."
- "Which employers have the most open registered nurse jobs in Texas?"
- "What share of project manager jobs are remote, hybrid or on-site?"
- "Pull every open job at Deloitte in Germany into a file."

## The data

Open jobs read from employer career sites and hiring platforms, refreshed continuously, with closed jobs removed.
Each job carries the employer, title, locations, work arrangement, pay as the employer published it, dates, and the
posting and apply links.

- Coverage by platform, country and company: [headcountlabs.com/coverage](https://headcountlabs.com/coverage/)
- Fields in a job record: [headcountlabs.com/docs/data-fields](https://headcountlabs.com/docs/data-fields/)
- REST API with the same filters: [headcountlabs.com/docs](https://headcountlabs.com/docs/)
- Open dataset on Hugging Face (CC BY 4.0): [HeadcountLabs/job-postings](https://huggingface.co/datasets/HeadcountLabs/job-postings)

## Privacy and support

Your client sends search filters and job IDs to api.headcountlabs.com and gets job data back. Headcount Labs keeps only
the usage counts needed for billing. See the [privacy policy](https://headcountlabs.com/privacy/) and
[terms](https://headcountlabs.com/terms/).

Support: [headcountlabs.com/contact](https://headcountlabs.com/contact/) or support@headcountlabs.com.

The examples and docs in this repository are MIT licensed.
