---
layout: default
title: Home
---

<div class="bio-section">
  <a href="{{ '/about/' | relative_url }}" class="profile-link">
    <img src="{{ '/assets/images/profile-pic.png' | relative_url }}" alt="Ritchie Caruso" class="profile-pic">
  </a>
  <div class="bio-text">
    <h1>Hi, I'm Ritchie</h1>
    <p>I'm an ICT professional who loves making things. I automate workflows, build gizmos, and experiment in my homelab—constantly exploring how technology works by breaking it (legally, of course) and rebuilding it to be faster, better and more secure.</p>
  </div>
</div>

<hr class="section-separator">

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
    <img src="{{ '/assets/images/nas-blog/bench-test.webp' | relative_url }}" alt="NAS Server Build">
    <h3><a href="{{ '/2023/11/10/nas-build.html' | relative_url }}">Home NAS Server Build</a></h3>
    <p>Built a custom NAS server from scratch using Unraid, featuring 8x2TB drives in RAID configuration, Docker containers, support for VMs, Photoprism, Pi-hole and more.</p>
  </div>
</div>
  </div>

<div class="recent-posts">
<h2>Latest Posts</h2>

{% for post in site.posts limit:3 %}
  <div class="recent-post-item">
    <div class="post-content-wrapper">
      <h3><a href="{{ post.url | relative_url }}">{{ post.title }}</a></h3>
      <div class="post-date">{{ post.date | date: "%B %d, %Y" }}</div>
      <p>{{ post.excerpt | strip_html | truncatewords: 20 }}</p>
      <a class="read-more" href="{{ post.url | relative_url }}">Read More</a>
    </div>
    {% if post.thumbnail %}
      <div class="post-thumbnail">
        <a href="{{ post.url | relative_url }}">
          <img src="{{ post.thumbnail | relative_url }}" alt="{{ post.title }}" loading="lazy">
        </a>
      </div>
    {% elsif post.content contains '<img' %}
      {% assign img_start = post.content | split: '<img ' | last | split: 'src="' %}
      {% if img_start[1] %}
        {% assign img_src = img_start[1] | split: '"' | first %}
        <div class="post-thumbnail">
          <a href="{{ post.url | relative_url }}">
            <img src="{{ img_src }}" alt="{{ post.title }}" loading="lazy">
          </a>
        </div>
      {% endif %}
    {% endif %}
  </div>
{% endfor %}
</div>