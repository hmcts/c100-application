# Markup fixtures

This directory contains HTML fixtures to be used in [markup_smoke_tests.feature](/features/markup_smoke_tests.feature)

The idea is to have a sample of a few representative pages in the service containing form elements that are built using 
the gem [govuk_design_system_formbuilder](https://github.com/DFE-Digital/govuk_design_system_formbuilder) so we are more 
confident when upgrading to new versions of the gem and we can detect regressions and bugs in the markup, that otherwise 
would be difficult to catch.

These pages should be a mixture of simple text inputs, radios, checkboxes and some more elaborated form elements.

To add more fixtures, first render the page in a browser, as a user would see it.  
Then, inspect the HTML markup of the page and look inside the `<form>` tag for one or more `<div class="govuk-form-group">...</div>` 
and paste that exact markup (including the div containers) into a new fixture file.  
If there are more than one `<div>` copy all of them one after another as they appear in the page.

Then edit the cucumber scenario to add a new path and corresponding fixture. Make sure the test passes, and if not, check 
the fixture for any **unnecessary break lines**, in particular in the **localised copy**.

Repeat these steps, but generating a validation error on the page, so you can create a fixture of the markup containing 
errors. Not all pages produce errors so choose the ones that do.
