# Copilot Instructions for This Repo

- **Stack**: Static Jekyll site with `jekyll` + `jekyll-paginate` (see [_config.yml](_config.yml) and [Gemfile](Gemfile)). No external JS deps beyond inline theme toggle.
- **Do not edit** the generated output in [_site/](_site/) — edit sources and rebuild.
- **Site config** lives in [_config.yml](_config.yml): empty `baseurl`, `future: true` (future-dated posts publish), timezone `Australia/Melbourne`, pagination set to 5 posts per page at `/blog/page:num/`.
- **Layouts**: default page shell in [_layouts/default.html](_layouts/default.html) with nav + dark-mode toggle; blog posts use [_layouts/post.html](_layouts/post.html) to render title/date/meta.
- **Theme toggle** is inline JS in both layouts; keep the `#theme-toggle` button and `html.dark` class for dark-mode styling to keep behavior working.
- **Pages**: root Markdown pages (home, about, projects, contact) use the `default` layout. The homepage ([index.md](index.md)) conditionally loads extra CSS when `page.title == 'Home'`.
- **Blog index**: [blog/index.md](blog/index.md) loops `site.posts`; pagination works when `jekyll-paginate` is installed, otherwise the included fallback still lists posts. Per-page count is driven by `_config.yml`.
- **Posts** live under [_posts/](_posts/) with dated filenames. Use front matter with `layout: post`, `title`, `date`, and optional `tags`. Example: [_posts/2025-12-19-example-post.md](_posts/2025-12-19-example-post.md) shows layout: post with an image; the welcome sample uses `layout: default` but lacks post metadata display.
- **Drafts** live under [_drafts/](_drafts/) without date prefixes. Preview with `bundle exec jekyll serve --drafts`. When ready to publish, move to `_posts/` and add date prefix `YYYY-MM-DD-filename.md`.
- **Assets**: shared styles in [assets/css/style.css](assets/css/style.css); homepage extras in [assets/css/homepage.css](assets/css/homepage.css). Images go in [assets/images/](assets/images/); reference them via `{{ '/assets/images/...' | relative_url }}`.
- **Navigation** is duplicated in both layouts; update both if you add/remove top-level pages.
- **Build/serve** locally with Bundler: `bundle install` then `bundle exec jekyll serve --livereload`. Add `--future` only if you toggle `future: false` later; it's already true here.
- **Publish** by running `bundle exec jekyll build`; output lands in `_site/`. Avoid committing `_site/` unless intentionally versioning built HTML.
- **Content patterns**: Use Markdown with front matter; headings and lists render normally. Hero images are shown via Markdown image syntax in posts.
- **Pagination**: ensure `jekyll-paginate` stays in `plugins` and `Gemfile`; missing it will break `paginator` but the fallback in blog index prevents empty pages.
- **SEO/meta**: No plugins for SEO or feeds included; add per-page meta manually if needed.
- **Customization**: Update `site.title`, `description`, `email` in `_config.yml` and replace placeholder copy in pages and cards. Rename homepage cards / recent posts grid in [index.md](index.md).
- **Dark mode styles**: CSS uses `html.dark` vars; keep color tokens (`--bg`, `--text`, `--accent`) in sync across global and homepage CSS.
- **Routing**: Permalinks use Jekyll defaults; blog index pinned at `/blog/` via front matter `permalink`. Changing `baseurl` requires updating external links accordingly.
- **Testing/preview**: Rely on `bundle exec jekyll serve` for live preview; no automated tests are present.

If anything here is unclear or missing, tell me what to refine and I’ll update this file.
