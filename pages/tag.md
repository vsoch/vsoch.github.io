---
description: "Search"
permalink: /tag/
---

{% include scrolltop.html %}
<div class="row" style="margin:25px; padding:30px">
    <div class="col-lg-10">
    {% include tags.html %}

    {% for tag in tags %}
        {% unless forloop.first %}
        <hr style="margin-top:40px">
        {% endunless %}
        <div>
            <div style='margin-top:40px;'>
             <h4 style="font-weight:600;font-size:35px;color:{% include darkcolors.html %}">{{ tag }}
                <a class='no-after' style="cursor:pointer; text-decoration:none;" id="block-{{ tag }}"><i class="fa fa-link" style="font-size:16px;text-decoration:none;color:#999"></i></a>
             </h4>
            </div>
            {% for post in site.posts %}
               {% if post.tags contains tag %}
                   {% if post.date %}
                   <h5 style="margin:10px"> 
                       <span style="color:#999">{{ post.date | date: '%m %d %Y' }}:</span>
                       <a href="{{  post.url | prepend: site.baseurl }}">{{ post.title }}</a>
                   </h5>
                   {% endif %}
               {% endif %}
            {% endfor %}
        </div>
    {% endfor %}
    </div>
    <div style='margin-top:20px' style="position: absolute; right:5px; top:100px;">
    {% for tag in tags %}
        <p style="background-color:transparent;">
            <a href="#block-{{ tag }}" style="font-weight:600; text-decoration:none;">
                {{ tag }}
            </a>
        </p>
    {% endfor %}
    </div>
</div>
