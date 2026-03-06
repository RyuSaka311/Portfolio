# Session Resume Notes

Last updated: 2026-03-03

## Current Git State
- Branch: `master`
- Latest commit: `d99b92a` (Improve article readability with narrower content width)
- Working tree: clean (`master...origin/master`)

## What Is Implemented
- Public site name is anonymized as `dragon-enginner`.
- Domain is set to:
  - `https://kind-mud-063fee810.4.azurestaticapps.net`
- Blog top page has:
  - category-based article organization
  - right-side date tree archive
  - refreshed light/fresh color palette
  - animated background gradients
- Article pages are generated from Markdown sources.
- Article readability tuning:
  - `.article .content` max width is `780px`.

## Important Files
- Top page: `index.html`
- Styles: `style.css`
- Markdown sources: `posts-md/*.md`
- Generated articles: `posts/*.html`
- Generator script: `scripts/build-posts.ps1`
- SEO/static files: `robots.txt`, `sitemap.xml`, `favicon.svg`

## How To Resume
1. Edit article source in `posts-md/*.md`.
2. Regenerate article HTML:
   ```powershell
   ./scripts/build-posts.ps1 -BaseUrl "https://kind-mud-063fee810.4.azurestaticapps.net"
   ```
3. If needed, update top page links/categories/date tree in `index.html`.
4. Commit and push:
   ```powershell
   git add -A
   git commit -m "your message"
   git push origin master
   ```

## Suggested Next Improvements
- Auto-generate `index.html` article lists/date tree from `posts-md` metadata.
- Add OG image and per-article `og:image`.
- Add simple CI check to run generation before deploy.
