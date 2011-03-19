from django.shortcuts import render_to_response
from django.template import RequestContext


def serve_js_constants(request):
    return render_to_response('constants.js', context_instance=RequestContext(request))
