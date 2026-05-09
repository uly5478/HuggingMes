---
title: HuggingMes
emoji: 💬
colorFrom: blue
colorTo: indigo
sdk: docker
app_port: 7861
pinned: true
license: mit
secrets:
  - name: LLM_API_KEY
    description: "Your LLM provider API key for providers such as OpenRouter, Anthropic, OpenAI, Google, DeepSeek, xAI, and others."
  - name: LLM_MODEL
    description: "Model ID, such as openrouter/anthropic/claude-sonnet-4 or openai/gpt-4o."
  - name: GATEWAY_TOKEN
    description: "Strong token to secure your dashboard and API (generate: openssl rand -hex 32)."
  - name: HF_TOKEN
    description: "Hugging Face token with write access. Used for automatic workspace backup and HF providers."
---

<!-- Badges -->
[![GitHub Stars](https://img.shields.io/github/stars/NousResearch/hermes-agent?style=flat-square)](https://github.com/NousResearch/hermes-agent)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](https://opensource.org/licenses/MIT)
[![HF Space](https://img.shields.io/badge/🤗%20HuggingFace-Space-blue?style=flat-square)](https://huggingface.co/spaces)
[![Hermes](https://img.shields.io/badge/Hermes-Agent-indigo?style=flat-square)](https://github.com/NousResearch/hermes-agent)



---
*Made with ❤️ by [@somratpro](https://github.com/somratpro)*
