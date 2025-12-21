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
  {% if post.tags and post.tags.size > 0 %}
  <div class="post-tags" aria-label="Tags">
    {% for tag in post.tags %}
    <a class="tag-badge" href="{{ '/tags/' | relative_url }}#{{ tag | slugify: 'raw' }}">{{ tag }}</a>
    {% endfor %}
  </div>
  {% endif %}
  <p class="post-excerpt">{{ post.excerpt | strip_html | truncatewords: 30 }}</p>
  <a class="read-more" href="{{ post.url | relative_url }}">Read More</a>
</article>
{% endfor %}
</div>

<section class="tag-index" id="all-tags">
  {% assign tags = site.tags | sort %}
  {% if tags == empty %}
    <p>No tags yet.</p>
  {% else %}
    <div class="tag-list" aria-label="All tags">
      {% for tag in tags %}
      {% assign tag_name = tag[0] %}
      <a class="tag-badge" href="{{ '/tags/' | relative_url }}#{{ tag_name | slugify: 'raw' }}">{{ tag_name }} <span class="tag-count">({{ tag[1].size }})</span></a>
      {% endfor %}
    </div>
  {% endif %}
</section>

