# Search engine optimization

Search engine optimization is a special discipline and can be highly time consuming to polish it to the maximum.

In any case, there are some basics that need to be followed. Check this [SEO Starter Guide](https://developers.google.com/search/docs/fundamentals/seo-starter-guide) to update your page accordingly.

SEO of the site can be validated with online tools like [SEObility](https://freetools.seobility.net/).

## Google Analytics

Google provides [Analytics tool](https://analytics.google.com/) to gather statistics on your page visitors. To connect your site, register in Google,

Connecting a website to Google Analytics involves a series of steps that allow you to track and analyze your website's traffic.

### Step-by-Step Guide:

#### 1. **Sign Up for Google Analytics:**

- Go to the [Google Analytics website](https://analytics.google.com/).
- Sign in with your Google account.
- Follow the prompts to set up a new account.

#### 2. **Set Up a Property:**

- Once you're in Google Analytics, you need to set up a "Property" which represents your website.
- Click on **Admin** in the lower left corner.
- In the **Property** column, click on **+ Create Property**.
- Fill in the details for your website (name, website URL, time zone, etc.).

#### 3. **Get Your Tracking Code:**

- After creating the property, you will be guided to get your tracking ID and tracking code.
- Look for a section labeled "Tracking Info" or "Data Streams."
- You'll see a string that starts with 'UA-' â€“ this is your Tracking ID.
- You will also get a tracking code snippet (JavaScript) to add to your website.

#### 4. **Add the Tracking Code to Your Website:**

- Paste the tracking code snippet into the `<head>` tag of every page you want to track.

```html{4-11}
<!DOCTYPE html>
<html lang="en">
  <head>
    <!-- Global site tag (gtag.js) - Google Analytics -->
    <script async src="https://www.googletagmanager.com/gtag/js?id=YOUR_TRACKING_ID"></script>
    <script>
      window.dataLayer = window.dataLayer || [];
      function gtag(){dataLayer.push(arguments);}
      gtag('js', new Date());
      gtag('config', 'YOUR_TRACKING_ID');
    </script>
    <!-- other head items-->
  </head>
  <body>
    <!-- content -->
  </body>
</html>
```

#### 5. **Verify Installation:**

- Return to Google Analytics.
- Go to **Real-Time** reports to see if it's registering data.
- If you see active users, it means the tracking code is working.
