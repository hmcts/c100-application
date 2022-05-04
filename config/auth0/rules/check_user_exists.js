function (user, context, callback) {
    //
    // We need the base URL of the C100 application service, so the
    // rule knows how to build the endpoint to check if the user exists.
    // Add a key named APPLICATION_BASE_URL with value the base URL.
    // For obvious reasons, localhost will not work, so we bypass it.
    //
    // :configuration:
    const BEARER_TOKEN = configuration.BEARER_TOKEN;
    const APPLICATION_BASE_URL = configuration.APPLICATION_BASE_URL;
    // :configuration:

    var userExists = function (user, next) {
        if (APPLICATION_BASE_URL.match(/localhost/)) {
            return next(null, true);
        }

        request.get({
            uri: APPLICATION_BASE_URL + '/backoffice/users/' + user.email + '/exists',
            headers: {
                "Authorization": "Bearer " + BEARER_TOKEN
            },
            timeout: 5000
        }, function (error, response) {
            var status = parseInt(response.statusCode, 10);

            if (status === 200) {
                return next(null, true);
            } else if (status === 404) {
                return next(null, false);
            }
            return next(error);
        });
    };

    // Check the user has been granted access to the back office
    userExists(user, function (err, exists) {
        if (err) {
            return callback(err);
        }
        if (exists) {
            return callback(null, user, context);
        }

        callback('Unauthorised email address: ' + user.email);
    });
}
