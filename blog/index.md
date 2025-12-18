---
layout: default
title: Blog
paginate: 5
permalink: /blog/
---

# Blog

{%- comment -%}
If you haven't installed `jekyll-paginate`, `paginator` will be undefined and the page may be empty.
This fallback lists `site.posts` so posts appear without pagination. Install the plugin and revert if you prefer paginated pages.
{%- endcomment -%}

{% for post in site.posts %}
- <a href="{{ post.url | relative_url }}">{{ post.title }}</a> — {{ post.date | date: "%B %d, %Y" }}
{% endfor %}

