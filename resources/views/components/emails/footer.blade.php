{{ Illuminate\Mail\Markdown::parse('---') }}

Thank you,<br>
{{ config('app.name') ?? 'Hostly' }}

{{ Illuminate\Mail\Markdown::parse('[Contact Support](https://hostly.khulnasoft.com/docs/contact)') }}
