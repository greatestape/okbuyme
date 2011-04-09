class AuthRewriteMiddleware(object):
    def process_response(self, request, response):
        if 'WWW-Authenticate' in response and request.is_ajax():
            response['WWW-Authenticate'] = 'Django'
        return response