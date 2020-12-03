---
title: "Custom Login Required in Django"
date: 2020-12-03 12:30:00
---

<style>
.blob-code {
  padding-left: 20px !important;
}
</style>

I wanted to extend Django's default <a href="https://docs.djangoproject.com/en/3.1/topics/auth/default/#the-login-required-decorator" target="_blank">Login Required</a> decorator to bypass traditional Django authentication and (given that the application was configured to do so) instead use a session based, one time token presented to the user at application start,
akin to a notebook. This isn't hard to figure out, but since it took me more than
a quick moment to look things up, I thought I'd share the complete snippet I came up with.

## Customizing Login Required

```python

from django.contrib.auth import REDIRECT_FIELD_NAME
from django.shortcuts import render, resolve_url
from myapp.settings import cfg
from myapp import settings
from urllib.parse import urlparse

import uuid


def login_is_required(
    function=None, login_url=None, redirect_field_name=REDIRECT_FIELD_NAME
):
    """
    Decorator to extend login required to also check if a notebook auth is
    desired first (but you could customize this to be another check!)
    """

    def wrap(request, *args, **kwargs):

        # If we are using a notebook, the user is required to provide a token
        # This is just an example of what I was trying to do, you could customize this
        if cfg.NOTEBOOK or cfg.NOTEBOOK_ONLY and not request.session.get("notebook_auth"):
            request.session["notebook_token"] = str(uuid.uuid4())
            print("Enter token: %s" % request.session["notebook_token"])
            return render(request, "login/notebook.html")

        # If the user is authenticated, return the view right away
        if request.user.is_authenticated:
            return function(request, *args, **kwargs)

        # Otherwise, prepare login url (from django user_passes_test)
        # https://github.com/django/django/blob/master/django/contrib/auth/decorators.py#L10
        path = request.build_absolute_uri()
        resolved_login_url = resolve_url(login_url or settings.LOGIN_URL)
        login_scheme, login_netloc = urlparse(resolved_login_url)[:2]
        current_scheme, current_netloc = urlparse(path)[:2]
        if (not login_scheme or login_scheme == current_scheme) and (
            not login_netloc or login_netloc == current_netloc
        ):
            path = request.get_full_path()
        from django.contrib.auth.views import redirect_to_login

        return redirect_to_login(path, resolved_login_url, redirect_field_name)

    wrap.__doc__ = function.__doc__
    wrap.__name__ = function.__name__
    return wrap

```

And then usage looks like the following:

```python

from myapp.decorators import login_is_required

@login_is_required
def index(request):
    return render(request, "main/index.html")

```

This doesn't include the logic to check and generate the token, but that's a different thing!
I also made it available in a gist <a href="https://gist.github.com/vsoch/87854e6fe98e22448374a4851efc95e0" target="_blank">here</a>.
