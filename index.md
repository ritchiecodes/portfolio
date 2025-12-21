---
layout: default
title: Home
---

# Hi, I'm Your Name

Welcome to my portfolio — replace this text with a short intro.

<div class="projects-section">
<h2>Projects</h2>

<div class="projects-grid">
  <div class="project-card">
    <h3><a href="#">Project One</a></h3>
    <p>A brief description of your first project. Replace with your actual project details.</p>
  </div>
  <div class="project-card">
    <h3><a href="#">Project Two</a></h3>
    <p>A brief description of your second project. Replace with your actual project details.</p>
  </div>
  <div class="project-card">
    <h3><a href="#">Project Three</a></h3>
    <p>A brief description of your third project. Replace with your actual project details.</p>
  </div>
</div>
  </div>

<div class="recent-posts">
<h2>Latest Posts</h2>

{% for post in site.posts limit:3 %}
  <div class="recent-post-item">
    <h3><a href="{{ post.url | relative_url }}">{{ post.title }}</a></h3>
    <div class="post-date">{{ post.date | date: "%B %d, %Y" }}</div>
    <p>{{ post.excerpt | strip_html | truncatewords: 20 }}</p>
    <a class="read-more" href="{{ post.url | relative_url }}">Read More</a>
  </div>
{% endfor %}
</div>