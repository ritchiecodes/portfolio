---
layout: default
title: Contact
permalink: /contact/
---

# Contact

Feel free to reach out using the form below, or email me directly at ritchiecodes@gmail.com

<form id="contact-form" style="max-width: 600px; margin: 2rem 0;">
  <div style="margin-bottom: 1rem;">
    <label for="name" style="display: block; margin-bottom: 0.5rem; font-weight: 500;">Name</label>
    <input type="text" id="name" name="name" required style="width: 100%; padding: 0.5rem; border: 1px solid var(--border, #ccc); border-radius: 4px; background: var(--bg, #fff); color: var(--text, #000);">
  </div>
  
  <div style="margin-bottom: 1rem;">
    <label for="email" style="display: block; margin-bottom: 0.5rem; font-weight: 500;">Email</label>
    <input type="email" id="email" name="email" required style="width: 100%; padding: 0.5rem; border: 1px solid var(--border, #ccc); border-radius: 4px; background: var(--bg, #fff); color: var(--text, #000);">
  </div>
  
  <div style="margin-bottom: 1rem;">
    <label for="message" style="display: block; margin-bottom: 0.5rem; font-weight: 500;">Message</label>
    <textarea id="message" name="message" rows="5" required style="width: 100%; padding: 0.5rem; border: 1px solid var(--border, #ccc); border-radius: 4px; background: var(--bg, #fff); color: var(--text, #000); resize: vertical;"></textarea>
  </div>
  
  <button type="submit" style="padding: 0.75rem 2rem; background: var(--accent, #0066cc); color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 1rem; font-weight: 500;">Send Message</button>
  <div id="error-message" style="display: none; margin-top: 1rem; padding: 1rem; background: #fee; border: 1px solid #fcc; border-radius: 4px; color: #c33;"></div>
</form>

<script>
document.getElementById('contact-form').addEventListener('submit', function(e) {
  e.preventDefault();
  
  const errorDiv = document.getElementById('error-message');
  errorDiv.style.display = 'none';
  
  const name = document.getElementById('name').value;
  const email = document.getElementById('email').value;
  const message = document.getElementById('message').value;
  
  const subject = encodeURIComponent(`Contact from ${name}`);
  const body = encodeURIComponent(`Name: ${name}\nEmail: ${email}\n\nMessage:\n${message}`);
  
  const mailtoLink = `mailto:ritchiecodes@gmail.com?subject=${subject}&body=${body}`;
  
  // Try to open mailto link
  const mailtoWindow = window.open(mailtoLink, '_self');
  
  // Set a timeout to check if mailto failed
  setTimeout(function() {
    if (document.hasFocus()) {
      errorDiv.textContent = 'No email client found. Please email directly to ritchiecodes@gmail.com or copy your message and send manually.';
      errorDiv.style.display = 'block';
    }
  }, 1000);
});
</script>

<div style="display: flex; gap: 0.5rem; margin-top: 2rem;">
<a href="https://www.github.com/ritchiecodes" target="_blank" rel="noopener noreferrer">
  <img 
    src="/assets/images/skill-icons/github.svg"
    alt="github"
    width="48"
    title="GitHub">
</a>
<a href="https://www.linkedin.com/in/ritchiecaruso/" target="_blank" rel="noopener noreferrer">
  <img 
    src="/assets/images/skill-icons/linkedin.svg"
    alt="linkedin"
    width="48"
    title="LinkedIn">
</a>
<a href="https://www.linkedin.com/in/ritchiecaruso/" target="_blank" rel="noopener noreferrer">
  <img 
    src="/assets/images/skill-icons/discord.svg"
    alt="discord"
    width="48"
    title="Discord">
</a>
</div>
