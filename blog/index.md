---
layout: default
title: Blog
paginate: 5
permalink: /blog/
---

<h1>Blog</h1>


{%- comment -%}
If you haven't installed `jekyll-paginate`, `paginator` will be undefined and the page may be empty.
This fallback lists `site.posts` so posts appear without pagination. Install the plugin and revert if you prefer paginated pages.
{%- endcomment -%}

<div class="blog-list">
{% for post in site.posts %}
<article class="post-item">
  <h2 class="post-title"><a href="{{ post.url | relative_url }}">{{ post.title }}</a></h2>
  <div class="post-meta">{{ post.date | date: "%B %d, %Y" }}</div>
  <p class="post-excerpt">{{ post.excerpt | strip_html | truncatewords: 30 }}</p>
  <a class="read-more" href="{{ post.url | relative_url }}">Read More</a>
</article>
{% endfor %}
</div>

