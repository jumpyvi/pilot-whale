/*
   This file is part of Pilot Whale, a fork of Whaler by sdv43.

   Whaler is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License
   as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
   Whaler is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
   of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

   You should have received a copy of the GNU General Public License along with Whaler. If not, see <https://www.gnu.org/licenses/>.

   This fork, Pilot Whale, was created and modified by jumpyvi in 2025.
 */

namespace Utilities {
    errordomain HttpClientError {
        ERROR,
        ERROR_ACCESS,
        ERROR_NO_ENTRY
    }

    enum HttpClientMethod {
        GET,
        POST,
        DELETE,
    }

    /**
     * The http client for making requests.
     */
    class HttpClient : Object {
        public bool verbose = false;
        public string? unix_socket_path {get; set;}
        public string? base_url;

        /**
         * Creates a GET request to the specified url.
         *
         * @param url The url for the request.
         * @return The http response.
         * @throws HttpClientError If an error occurs during the request.
         */
        public async HttpClientResponse r_get (string url) throws HttpClientError {
            return yield this.request (Utilities.HttpClientMethod.GET, url, new HttpClientResponse ());
        }

        /**
         * Makes a POST request to the specified url.
         *
         * @param url The url for the request.
         * @return The http response.
         * @throws HttpClientError If an error occurs during the request.
         */
        public async HttpClientResponse r_post (string url) throws HttpClientError {
            return yield this.request (Utilities.HttpClientMethod.POST, url, new HttpClientResponse ());
        }

        /**
         * Makes a DELETE request to the specified url.
         *
         * @param url The url for the request.
         * @return The http response.
         * @throws HttpClientError If an error occurs during the request.
         */
        public async HttpClientResponse r_delete (string url) throws HttpClientError {
            return yield this.request (Utilities.HttpClientMethod.DELETE, url, new HttpClientResponse ());
        }

        /**
         * Makes an HTTP request with the specified method and URL.
         *
         * @param method The http method to use.
         * @param url The url for the request.
         * @param response The http response object.
         * @return The http response object.
         * @throws HttpClientError If an error occurs during the request.
         */
        public async HttpClientResponse request (HttpClientMethod method, string url, HttpClientResponse response) throws HttpClientError {
            var curl = new Curl.EasyHandle ();

            Curl.Code r;

            r = curl.setopt (Curl.Option.VERBOSE, this.verbose ? 1 : 0);
            assert_true (r == Curl.Code.OK);
            r = curl.setopt (Curl.Option.URL, (this.base_url ?? "") + url);
            assert_true (r == Curl.Code.OK);
            r = curl.setopt (Curl.Option.UNIX_SOCKET_PATH, this.unix_socket_path);
            assert_true (r == Curl.Code.OK);
            r = curl.setopt (Curl.Option.CUSTOMREQUEST, this.get_request_method (method));
            assert_true (r == Curl.Code.OK);
            r = curl.setopt (Curl.Option.WRITEDATA, (void*)response.memory_stream);
            assert_true (r == Curl.Code.OK);
            r = curl.setopt (Curl.Option.WRITEFUNCTION, HttpClientResponse.read_body_data);
            assert_true (r == Curl.Code.OK);

            yield this.perform (curl);

            long curl_errno = -1;

            r = curl.getinfo (Curl.Info.OS_ERRNO, &curl_errno);
            assert_true (r == Curl.Code.OK);

            if (curl_errno == Posix.ENOENT) {
                throw new HttpClientError.ERROR_NO_ENTRY (strerror ((int)curl_errno));
            } else if (curl_errno == Posix.EACCES) {
                throw new HttpClientError.ERROR_ACCESS (strerror ((int)curl_errno));
            } else if (curl_errno > 0) {
                throw new HttpClientError.ERROR ("Unknown error");
            }

            if (r == Curl.Code.OK) {
                curl.getinfo (Curl.Info.RESPONSE_CODE, &response.code);

                return response;
            }

            throw new HttpClientError.ERROR (Curl.Global.strerror (r));
        }

        /**
         * Gets the string of the http method.
         *
         * @param method The http method.
         * @return The string version of the method.
         */
        public string get_request_method (HttpClientMethod method) {
            var result = "";

            switch (method) {
                case HttpClientMethod.GET:
                    result = "GET";
                    break;

                case HttpClientMethod.POST:
                    result = "POST";
                    break;

                case HttpClientMethod.DELETE:
                    result = "DELETE";
                    break;
            }

            return result;
        }

        /**
         * Performs the curl request.
         *
         * @param curl The curl easy handle.
         * @return The curl code.
         * @throws HttpClientError If an error occurs while performing the request.
         */
        private async Curl.Code perform (Curl.EasyHandle curl) throws HttpClientError {
            string? err_msg = null;
            var r = Curl.Code.OK;

            var task = new Task (this, null, (obj, cl_task) => {
                try {
                    r = (Curl.Code)cl_task.propagate_int ();
                } catch (Error error) {
                    err_msg = error.message;
                } finally {
                    this.perform.callback ();
                }
            });

            task.set_task_data (curl, null);
            task.run_in_thread ((task, http_client, curl, cancellable) => {
                unowned var cl_curl = (Curl.EasyHandle)curl;

                var cl_r = cl_curl.perform ();
                task.return_int (cl_r);
            });

            yield;

            if (err_msg != null) {
                throw new HttpClientError.ERROR (@"Curl perform error: $err_msg");
            }

            return r;
        }
    }

    /**
     * An HTTP response.
     */
    class HttpClientResponse : Object {
        public int code;
        public MemoryInputStream memory_stream {get; construct set;}
        public DataInputStream body_data_stream {get; construct set;}

        /**
         * Creates a new HttpClientResponse.
         */
        public HttpClientResponse() {
            this.code = 0;
            this.memory_stream = new MemoryInputStream ();
            this.body_data_stream = new DataInputStream (this.memory_stream);
        }

        /**
         * Reads the body data from the response.
         *
         * @param buf The buffer.
         * @param size The size of each element.
         * @param nmemb The number of elements.
         * @param data The response memory stream.
         * @return The number of bytes read.
         */
        public static size_t read_body_data (void* buf, size_t size, size_t nmemb, void* data) {
            size_t real_size = size * nmemb;
            uint8[] buffer = new uint8[real_size];
            var response_memory_stream = (MemoryInputStream)data;

            Posix.memcpy ((void*)buffer, buf, real_size);
            response_memory_stream.add_data (buffer);

            return real_size;
        }
    }
}
