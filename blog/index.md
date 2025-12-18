---
layout: default
title: Blog
---

# Blog

{% for post in site.posts %}
- <a href="{{ post.url | relative_url }}">{{ post.title }}</a> — {{ post.date | date: "%B %d, %Y" }}
{% endfor %}
