---
title: "Good First Issues"
date: 2020-02-29 10:25:00
---

How do you get involved in research software engineering? Well, either
you can come up with your own project (arguably challenging because
you depend on yourself for learning), or you find an existing project
that already needs some help, and might have other motivated folks to work with.

## Rseng on GitHub

If you haven't seen, I've created the <a target="_blank" href="https://github.com/rseng">rseng</a> organization as a place for open source research software engineering projects. This can mean projects on the "meta level," such as tools for open source research software engineering and the community, or actual projects worked on by a geographically diverse group
that need a home.

<div style="padding:20px">
<img src="https://raw.githubusercontent.com/vsoch/vsoch.github.io/master/assets/images/posts/good-first-issues/rseng.png">
</div>

So if you are a research software engineer and you like open source, reach out to me (@vsoch) on Twitter or GitHub to be invited to the organization.

## Awesome Rseng

Let's say you want to get involved in open source research software engineering, and maybe you even have a domain or topic of interest.
How do you get started? Well, you might try to search around GitHub
for organizations that you know are doing research. But wouldn't it be
nice to have a curated list of these organizations? This is what 
awesome lists are awesome for!

<div style="padding:20px">
<img src="https://raw.githubusercontent.com/vsoch/vsoch.github.io/master/assets/images/posts/good-first-issues/awesome.png">
</div>

If you visit <a target="_blank" href="https://github.com/rseng/awesome-rseng">rseng/awesome-rseng</a> on GitHub, you can browse organizations by category, or even contribute an organization or two.

## Good First Issues

I wanted the awesome-rseng repository to deploy a GitHub pages site at <a href="https://rseng.github.io/awesome-rseng/" target="_blank">https://rseng.github.io/awesome-rseng/</a> that would be an entrypoint to find good first issues (a label for GitHub issues) associated with some subset of repos.
To make this possible, I created a <a href="https://github.com/rseng/good-first-issues" target="_blank">good first issues</a> GitHub action that
you can add to a workflow that will:


<ol class="custom-counter">
<li>Read in a repos.txt file with repositories and tags</li>
<li>Generate an interface in a docs/ subfolder for GitHub pages</li>
<li>Use the GitHub API to find good first issues</li>
<li>Update the interface</li>
</ol>


And then it's up to you to add these to a branch for a pull request,
or a direct push. The simple usage of the action to generate the interface
looks like this:

```yaml
    - name: Generate First Issues
      uses: rseng/good-first-issues@v1.0.0
      with:
        token: {% raw %}${{ secrets.GITHUB_TOKEN }}{% endraw %}
```

And this assumes a file called `repos.txt` in the root of the repository.
The content of that file should include a list of repos, followed by a
comma separated list of tags for it. Here is what the early
content of the awesome-rseng repos.txt looked like:

```
https://github.com/spack/spack hpc,package-management,python
https://github.com/singularityhub/sregistry containers,singularity,python
https://github.com/pangeo-data/pangeo-binder geoscience
https://github.com/pangeo-data/helm-chart geoscience,kubernetes
https://github.com/CEED/libCEED hpc
https://github.com/poldracklab/fmriprep neuroscience,python
https://github.com/poldracklab/smriprep neuroscience,python
https://github.com/slaclab/pysmurf national-lab,python
https://github.com/nipy/nibabel neuroscience,python
```

If you want to change the location or name of the file, you can specify
that in the action:

```yaml
    - name: Generate First Issues
      uses: rseng/good-first-issues@v1.0.0
      with:
        token: {% raw %}${{ secrets.GITHUB_TOKEN }}{% endraw %}
        repos-file: '.github/repos.txt'
```

The rendered interface, using the tags and repositories above, looks like
this!

<div style="padding:20px">
<img src="https://raw.githubusercontent.com/rseng/good-first-issues/master/img/good-first-issues.png">
</div>


It's intended to be simple so that an organization can customize the style
to fit its branding. Note that we also grab other labels that are associated with the repositories.
If this turns out to be too many, we could always limit to GitHub's
pre-determined set. Also note that you might want to update the tag
or commit of the action used. Version v1.0.0 was just released.

## Why Should I Care?

If you are immersed in the world of being an RSE, or perhaps an RSE
for a specific domain, it's easy to forget that
there are folks out there that would love to learn, but don't know where to
start. If you aren't an RSE but are part of a GitHub community, the same
case is true for your projects. Hopefully this small set of tools, both the awesome list and
the action, can help you to find RSE related projects along with
identify and share good first issues for your own set of repositories 
if you deploy the action. Have fun, friends!
