<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Trackie Branding Assets</title>
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }
    
    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
      background: #060E20;
      color: #E2E8F0;
      min-height: 100vh;
    }
    
    .container {
      max-width: 1200px;
      margin: 0 auto;
      padding: 40px 20px;
    }
    
    header {
      text-align: center;
      margin-bottom: 60px;
    }
    
    h1 {
      font-size: 48px;
      font-weight: 900;
      background: linear-gradient(135deg, #8B5CF6, #22D3EE, #8B5CF6);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      background-clip: text;
      margin-bottom: 16px;
    }
    
    .subtitle {
      font-size: 20px;
      color: rgba(226, 232, 240, 0.7);
    }
    
    section {
      margin-bottom: 80px;
    }
    
    h2 {
      font-size: 28px;
      font-weight: 700;
      margin-bottom: 24px;
      color: #fff;
      border-bottom: 2px solid rgba(139, 92, 246, 0.3);
      padding-bottom: 12px;
    }
    
    .asset-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
      gap: 24px;
    }
    
    .asset-card {
      background: rgba(255, 255, 255, 0.05);
      border: 1px solid rgba(139, 92, 246, 0.2);
      border-radius: 16px;
      padding: 24px;
      text-align: center;
    }
    
    .asset-card h3 {
      font-size: 18px;
      margin-bottom: 8px;
      color: #fff;
    }
    
    .asset-card p {
      font-size: 14px;
      color: rgba(226, 232, 240, 0.6);
      margin-bottom: 16px;
    }
    
    .asset-preview {
      background: #060E20;
      border-radius: 12px;
      padding: 20px;
      margin-bottom: 16px;
      display: flex;
      align-items: center;
      justify-content: center;
      min-height: 150px;
    }
    
    .asset-preview img {
      max-width: 100%;
      height: auto;
    }
    
    .color-palette {
      display: flex;
      gap: 16px;
      flex-wrap: wrap;
    }
    
    .color-swatch {
      text-align: center;
    }
    
    .color-box {
      width: 100px;
      height: 100px;
      border-radius: 12px;
      margin-bottom: 8px;
      border: 2px solid rgba(255, 255, 255, 0.1);
    }
    
    .color-name {
      font-weight: 600;
      margin-bottom: 4px;
    }
    
    .color-hex {
      font-family: monospace;
      color: rgba(226, 232, 240, 0.6);
      font-size: 14px;
    }
    
    .download-btn {
      display: inline-block;
      padding: 10px 20px;
      background: linear-gradient(135deg, rgba(139, 92, 246, 0.2), rgba(34, 211, 238, 0.2));
      border: 1px solid rgba(139, 92, 246, 0.4);
      border-radius: 8px;
      color: #fff;
      text-decoration: none;
      font-size: 14px;
      font-weight: 500;
      transition: all 0.3s ease;
    }
    
    .download-btn:hover {
      background: linear-gradient(135deg, rgba(139, 92, 246, 0.4), rgba(34, 211, 238, 0.4));
      transform: translateY(-2px);
    }
    
    .usage-guide {
      background: rgba(255, 255, 255, 0.05);
      border: 1px solid rgba(139, 92, 246, 0.2);
      border-radius: 16px;
      padding: 32px;
    }
    
    .usage-guide h3 {
      font-size: 20px;
      margin-bottom: 16px;
      color: #fff;
    }
    
    .usage-guide pre {
      background: rgba(0, 0, 0, 0.3);
      padding: 16px;
      border-radius: 8px;
      overflow-x: auto;
      font-family: 'Monaco', 'Menlo', monospace;
      font-size: 14px;
      color: #E2E8F0;
    }
    
    .usage-guide ul {
      list-style: none;
      margin-top: 16px;
    }
    
    .usage-guide li {
      padding: 8px 0;
      padding-left: 24px;
      position: relative;
    }
    
    .usage-guide li::before {
      content: '•';
      color: #8B5CF6;
      position: absolute;
      left: 0;
    }
    
    footer {
      text-align: center;
      padding: 40px 0;
      border-top: 1px solid rgba(139, 92, 246, 0.2);
      margin-top: 60px;
      color: rgba(226, 232, 240, 0.5);
    }
  </style>
</head>
<body>
  <div class="container">
    <header>
      <h1>Trackie Branding Assets</h1>
      <p class="subtitle">Liquid Nebula Design System • Glassmorphism Effects</p>
    </header>
    
    <!-- Logo Section -->
    <section>
      <h2>Logos</h2>
      <div class="asset-grid">
        <div class="asset-card">
          <h3>Main Logo</h3>
          <p>Primary logo with glass sphere effect</p>
          <div class="asset-preview">
            <img src="assets/branding/logo.svg" alt="Trackie Logo">
          </div>
          <a href="assets/branding/logo.svg" download class="download-btn">Download SVG</a>
        </div>
        
        <div class="asset-card">
          <h3>Small Logo</h3>
          <p>For badges and compact spaces</p>
          <div class="asset-preview">
            <img src="assets/branding/logo-sm.svg" alt="Trackie Small Logo">
          </div>
          <a href="assets/branding/logo-sm.svg" download class="download-btn">Download SVG</a>
        </div>
      </div>
    </section>
    
    <!-- GitHub Assets -->
    <section>
      <h2>GitHub Assets</h2>
      <div class="asset-grid">
        <div class="asset-card">
          <h3>Social Preview Thumbnail</h3>
          <p>1280x640px - Repository social preview</p>
          <div class="asset-preview" style="padding: 0; overflow: hidden;">
            <img src="assets/branding/github-thumbnail.svg" alt="GitHub Thumbnail" style="width: 100%;">
          </div>
          <a href="assets/branding/github-thumbnail.svg" download class="download-btn">Download SVG</a>
        </div>
        
        <div class="asset-card">
          <h3>Banner</h3>
          <p>800x200px - For README headers</p>
          <div class="asset-preview" style="padding: 0; overflow: hidden;">
            <img src="assets/branding/github-banner.svg" alt="GitHub Banner" style="width: 100%;">
          </div>
          <a href="assets/branding/github-banner.svg" download class="download-btn">Download SVG</a>
        </div>
      </div>
    </section>
    
    <!-- Color Palette -->
    <section>
      <h2>Color Palette</h2>
      <div class="color-palette">
        <div class="color-swatch">
          <div class="color-box" style="background: #8B5CF6;"></div>
          <div class="color-name">Violet Liquid</div>
          <div class="color-hex">#8B5CF6</div>
        </div>
        <div class="color-swatch">
          <div class="color-box" style="background: #22D3EE;"></div>
          <div class="color-name">Electric Cyan</div>
          <div class="color-hex">#22D3EE</div>
        </div>
        <div class="color-swatch">
          <div class="color-box" style="background: #060E20;"></div>
          <div class="color-name">Deep Space</div>
          <div class="color-hex">#060E20</div>
        </div>
        <div class="color-swatch">
          <div class="color-box" style="background: linear-gradient(135deg, #8B5CF6, #22D3EE);"></div>
          <div class="color-name">Gradient</div>
          <div class="color-hex">#8B5CF6 → #22D3EE</div>
        </div>
      </div>
    </section>
    
    <!-- Usage Guide -->
    <section>
      <h2>Usage Guide</h2>
      <div class="usage-guide">
        <h3>README.md Usage</h3>
        <pre>&lt;div align="center"&gt;
  &lt;img src="assets/branding/logo.svg" alt="Trackie Logo" width="120"&gt;
  &lt;h1&gt;Trackie&lt;/h1&gt;
  &lt;p&gt;Track Everything, Everywhere&lt;/p&gt;
&lt;/div&gt;</pre>
        
        <h3 style="margin-top: 32px;">Social Preview Setup</h3>
        <ul>
          <li>Go to your GitHub repository Settings</li>
          <li>Scroll to "Social Preview"</li>
          <li>Upload the github-thumbnail.svg or a PNG conversion</li>
        </ul>
        
        <h3 style="margin-top: 32px;">Design Guidelines</h3>
        <ul>
          <li>Always use on dark backgrounds (#060E20) for best glassmorphism effect</li>
          <li>Maintain minimum 20% breathing space around the logo</li>
          <li>Use the gradient palette consistently across all materials</li>
        </ul>
      </div>
    </section>
    
    <footer>
      <p>Trackie • Liquid Nebula Design • Powered by Flutter</p>
    </footer>
  </div>
</body>
</html>
