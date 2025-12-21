---
layout: default
title: Tags
permalink: /tags/
---

<h1>Tags</h1>

{% assign tags = site.tags | sort %}
{% if tags == empty %}
<p>No tags yet.</p>
{% endif %}

<div class="tag-index">
  <div class="tag-list" aria-label="All tags">
    {% for tag in tags %}
    {% assign tag_name = tag[0] %}
    <a class="tag-badge" href="#{{ tag_name | slugify: 'raw' }}">{{ tag_name }} <span class="tag-count">({{ tag[1].size }})</span></a>
    {% endfor %}
  </div>

  {% for tag in tags %}
  {% assign tag_name = tag[0] %}
  {% assign posts = tag[1] | sort: 'date' | reverse %}
  <section id="{{ tag_name | slugify: 'raw' }}" class="tag-section">
    <h2>{{ tag_name }} <span class="tag-count">({{ posts.size }})</span></h2>
    <ul class="tag-posts">
      {% for post in posts %}
      <li>
        <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
        <span class="post-meta">{{ post.date | date: "%B %d, %Y" }}</span>
      </li>
      {% endfor %}
    </ul>
  </section>
  {% endfor %}
</div>
