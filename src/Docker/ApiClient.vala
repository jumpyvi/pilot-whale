/*
   This file is part of Pilot Whale, a fork of Whaler by sdv43.

   Whaler is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License
   as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
   Whaler is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
   of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

   You should have received a copy of the GNU General Public License along with Whaler. If not, see <https://www.gnu.org/licenses/>.

   This fork, Pilot Whale, was created and modified by jumpyvi in 2025.
 */

using Utilities;
using Utilities.Constants;

namespace Docker {
    errordomain ApiClientError {
        ERROR,
        ERROR_JSON,
        ERROR_ACCESS,
        ERROR_NO_ENTRY,
    }

    struct Container {
        public string id;
        public string name;
        public string image;
        public string state;
        public string? label_project;
        public string? label_service;
        public string? label_config;
        public string? label_workdir;
    }

    struct Image {
        public string? description;
        public bool is_official;
        public bool is_automated;
        public string name;
        public int64 star_count;
    }

    struct LocalImage {
        public string? name;
        public string tag;
        public string id;
        public DateTime created_date;
        public float size;
        public int n_attached_containers;
    }

    struct ContainerInspectInfo {
        public string name;
        public string image;
        public string status;
        public bool is_tty;
        public string[]? binds;
        public string[]? envs;
        public string[]? ports;
    }

    struct DockerVersionInfo {
        public string version;
        public string api_version;
    }

    /**
    * Creates a new ApiClient instance.
    */
    class ApiClient : Object {
        public HttpClient http_client;

        public ApiClient () {
            this.http_client = new HttpClient ();
            this.http_client.verbose = false;
            this.http_client.base_url = @"http://localhost/v$(DOCKER_ENIGINE_API_VERSION)";
            this.http_client.unix_socket_path = DOCKER_ENGINE_SOCKET_PATH;
        }

        /**
         * Parses JSON and returns the root Json.Node.
         *
         * @param data The JSON string to parse.
         * @return The root Json.Node.
         * @throws ApiClientError If the JSON cannot be parsed.
         */
        private static Json.Node parse_json (string data) throws ApiClientError {
            try {
                var parser = new Json.Parser ();
                parser.load_from_data (data);

                var node = parser.get_root ();

                if (node == null) {
                    throw new ApiClientError.ERROR_JSON ("Cannot parse json from: %s", data);
                }

                return node;
            } catch (Error error) {
                throw new ApiClientError.ERROR_JSON (error.message);
            }
        }


        public async LocalImage[] list_local_images () throws ApiClientError {
            try {
                var local_image_list = new LocalImage[0];
                var resp = yield this.http_client.r_get ("/images/json");

                //
                if (resp.code == 400) {
                    throw new ApiClientError.ERROR ("Bad parameter");
                }
                if (resp.code == 500) {
                    throw new ApiClientError.ERROR ("Server error");
                }

                //
                var json = "";
                string? line = null;

                while ((line = yield resp.body_data_stream.read_line_utf8_async ()) != null) {
                    json += line;
                }

                //
                var root_node = parse_json (json);
                var root_array = root_node.get_array ();
                assert_nonnull (root_array);

                foreach (var image_node in root_array.get_elements ()) {
                    var local_image = LocalImage ();
                    var local_image_object = image_node.get_object ();
                    assert_nonnull (local_image_object);

                    //
                    local_image.id = local_image_object.get_string_member_with_default ("Id", "00000");
                    var repo_tags = local_image_object.get_array_member ("RepoTags");
                    if (repo_tags != null && repo_tags.get_length () > 0) {
                        var repo_tag = repo_tags.get_string_element (0);
                        var parts = repo_tag.split (":");
                        local_image.name = parts[0];
                        local_image.tag = parts.length > 1 ? parts[1] : "latest";
                    } else {
                        local_image.name = "Unnamed";
                        local_image.tag = "latest";
                    }
                    local_image.size = local_image_object.get_int_member_with_default ("Size", 1294338799);
                    GLib.DateTime created_time = new GLib.DateTime.from_unix_utc (local_image_object.get_int_member ("Created"));
                    local_image.created_date = created_time;

                    local_image_list += local_image;
                }

                return local_image_list;
            } catch (HttpClientError error) {
                if (error is HttpClientError.ERROR_NO_ENTRY) {
                    throw new ApiClientError.ERROR_NO_ENTRY (error.message);
                } else if (error is HttpClientError.ERROR_ACCESS) {
                    throw new ApiClientError.ERROR_ACCESS (error.message);
                } else {
                    throw new ApiClientError.ERROR (error.message);
                }
            } catch (IOError error) {
                throw new ApiClientError.ERROR (error.message);
            }
        }


        /**
         * Lists all containers.
         *
         * @return An array of container.
         * @throws ApiClientError If an error occurs while listing containers.
         */
        public async Container[] list_containers () throws ApiClientError {
            try {
                var container_list = new Container[0];
                var resp = yield this.http_client.r_get ("/containers/json?all=true");

                //
                if (resp.code == 400) {
                    throw new ApiClientError.ERROR ("Bad parameter");
                }
                if (resp.code == 500) {
                    throw new ApiClientError.ERROR ("Server error");
                }

                //
                var json = "";
                string? line = null;

                while ((line = yield resp.body_data_stream.read_line_utf8_async ()) != null) {
                    json += line;
                }

                //
                var root_node = parse_json (json);
                var root_array = root_node.get_array ();
                assert_nonnull (root_array);

                foreach (var container_node in root_array.get_elements ()) {
                    var container = Container ();
                    var container_object = container_node.get_object ();
                    assert_nonnull (container_object);

                    //
                    container.id = container_object.get_string_member ("Id");
                    container.image = container_object.get_string_member ("Image");
                    container.state = container_object.get_string_member ("State");

                    //
                    var name_array = container_object.get_array_member ("Names");

                    foreach (var name_node in name_array.get_elements ()) {
                        container.name = name_node.get_string ();
                        assert_nonnull (container.name);
                        break;
                    }

                    //
                    var labels_object = container_object.get_object_member ("Labels");
                    assert_nonnull (labels_object);

                    if (labels_object.has_member ("com.docker.compose.project")) {
                        container.label_project = labels_object.get_string_member ("com.docker.compose.project");
                    }
                    if (labels_object.has_member ("com.docker.compose.service")) {
                        container.label_service = labels_object.get_string_member ("com.docker.compose.service");
                    }
                    if (labels_object.has_member ("com.docker.compose.project.config_files")) {
                        container.label_config = labels_object.get_string_member ("com.docker.compose.project.config_files");
                    }
                    if (labels_object.has_member ("com.docker.compose.project.working_dir")) {
                        container.label_workdir = labels_object.get_string_member ("com.docker.compose.project.working_dir");
                    }

                    //
                    container_list += container;
                }

                return container_list;
            } catch (HttpClientError error) {
                if (error is HttpClientError.ERROR_NO_ENTRY) {
                    throw new ApiClientError.ERROR_NO_ENTRY (error.message);
                } else if (error is HttpClientError.ERROR_ACCESS) {
                    throw new ApiClientError.ERROR_ACCESS (error.message);
                } else {
                    throw new ApiClientError.ERROR (error.message);
                }
            } catch (IOError error) {
                throw new ApiClientError.ERROR (error.message);
            }
        }

        /**
         * Pulls an image from a repo.
         *
         * @param image_name The name/path of the image to pull.
         * @return True if the image was pulled successfully.
         * @throws ApiClientError If an error occurs while pulling the image.
         */
        public async bool pull_image (string image_name) throws ApiClientError {
            try {
                var resp = yield this.http_client.r_post (@"/images/create?fromImage=" + image_name);

                if (resp.code == 404) {
                    throw new ApiClientError.ERROR ("No such image");
                }
                if (resp.code == 500) {
                    throw new ApiClientError.ERROR ("Server error");
                }

                return true;
            } catch (HttpClientError error) {
                throw new ApiClientError.ERROR (error.message);
            }
        }

        /**
         * Searches for remote images matching a search string.
         *
         * @param search_string The search string to use.
         * @return An array of Image.
         * @throws ApiClientError If an error occurs while searching for images.
         */
        public async Image[] find_remote_image_from_string (string search_string) throws ApiClientError {
            try {
                var image_list = new Image[0];
                var resp = yield this.http_client.r_get ("/images/search?term=" + search_string);

                //
                if (resp.code == 400) {
                    throw new ApiClientError.ERROR ("Bad parameter");
                }
                if (resp.code == 500) {
                    throw new ApiClientError.ERROR ("Server error (ignore if pulling from link)");
                }

                //
                var json = "";
                string? line = null;

                while ((line = yield resp.body_data_stream.read_line_utf8_async ()) != null) {
                    json += line;
                }

                //
                var root_node = parse_json (json);
                var root_array = root_node.get_array ();
                assert_nonnull (root_array);

                foreach (var image_node in root_array.get_elements ()) {
                    var image = Image ();
                    var container_object = image_node.get_object ();
                    assert_nonnull (container_object);

                    //
                    image.star_count = container_object.get_int_member_with_default ("star_count", 0);
                    image.is_official = container_object.get_boolean_member_with_default ("is_official", false);
                    image.name = container_object.get_string_member ("name");
                    image.is_automated = container_object.get_boolean_member_with_default ("is_automated", false);
                    image.description = container_object.get_string_member_with_default ("description", "No description found");

                    image_list += image;
                }

                return image_list;
            } catch (HttpClientError error) {
                if (error is HttpClientError.ERROR_NO_ENTRY) {
                    throw new ApiClientError.ERROR_NO_ENTRY (error.message);
                } else if (error is HttpClientError.ERROR_ACCESS) {
                    throw new ApiClientError.ERROR_ACCESS (error.message);
                } else {
                    throw new ApiClientError.ERROR (error.message);
                }
            } catch (IOError error) {
                throw new ApiClientError.ERROR (error.message);
            }
        }

        /**
         * Starts a container.
         *
         * @param container The container to start.
         * @throws ApiClientError If an error occurs while starting the container.
         */
        public async void start_container (Container container) throws ApiClientError {
            try {
                var resp = yield this.http_client.r_post (@"/containers/$(container.id)/start");

                if (resp.code == 304) {
                    throw new ApiClientError.ERROR ("Container already started");
                }
                if (resp.code == 404) {
                    throw new ApiClientError.ERROR ("No such container");
                }
                if (resp.code == 500) {
                    throw new ApiClientError.ERROR ("Server error");
                }
            } catch (HttpClientError error) {
                throw new ApiClientError.ERROR (error.message);
            }
        }

        /**
         * Stops a container.
         *
         * @param container The container to stop.
         * @throws ApiClientError If an error occurs while stopping the container.
         */
        public async void stop_container (Container container) throws ApiClientError {
            try {
                var resp = yield this.http_client.r_post (@"/containers/$(container.id)/stop");

                if (resp.code == 304) {
                    throw new ApiClientError.ERROR ("Container already stopped");
                }
                if (resp.code == 404) {
                    throw new ApiClientError.ERROR ("No such container");
                }
                if (resp.code == 500) {
                    throw new ApiClientError.ERROR ("Server error");
                }
            } catch (HttpClientError error) {
                throw new ApiClientError.ERROR (error.message);
            }
        }

        /**
         * Pauses a container.
         *
         * @param container The container to pause.
         * @throws ApiClientError If an error occurs while pausing the container.
         */
        public async void pause_container (Container container) throws ApiClientError {
            try {
                var resp = yield this.http_client.r_post (@"/containers/$(container.id)/pause");

                if (resp.code == 404) {
                    throw new ApiClientError.ERROR ("No such container");
                }
                if (resp.code == 500) {
                    throw new ApiClientError.ERROR ("Server error");
                }
            } catch (HttpClientError error) {
                throw new ApiClientError.ERROR (error.message);
            }
        }

        /**
         * Restarts a container.
         *
         * @param container The container to restart.
         * @throws ApiClientError If an error occurs while restarting the container.
         */
        public async void restart_container (Container container) throws ApiClientError {
            try {
                var resp = yield this.http_client.r_post (@"/containers/$(container.id)/restart");

                if (resp.code == 404) {
                    throw new ApiClientError.ERROR ("No such container");
                }
                if (resp.code == 500) {
                    throw new ApiClientError.ERROR ("Server error");
                }
            } catch (HttpClientError error) {
                throw new ApiClientError.ERROR (error.message);
            }
        }

        /**
         * Unpauses a container.
         *
         * @param container The container to unpause.
         * @throws ApiClientError If an error occurs while unpausing the container.
         */
        public async void unpause_container (Container container) throws ApiClientError {
            try {
                var resp = yield this.http_client.r_post (@"/containers/$(container.id)/unpause");

                if (resp.code == 404) {
                    throw new ApiClientError.ERROR ("No such container");
                }
                if (resp.code == 500) {
                    throw new ApiClientError.ERROR ("Server error");
                }
            } catch (HttpClientError error) {
                throw new ApiClientError.ERROR (error.message);
            }
        }

        /**
         * Removes a container.
         *
         * @param container The container to remove.
         * @throws ApiClientError If an error occurs while removing the container.
         */
        public async void remove_container (Container container) throws ApiClientError {
            try {
                var resp = yield this.http_client.r_delete (@"/containers/$(container.id)");

                if (resp.code == 400) {
                    throw new ApiClientError.ERROR ("Bad parameter");
                }
                if (resp.code == 404) {
                    throw new ApiClientError.ERROR ("No such container");
                }
                if (resp.code == 409) {
                    throw new ApiClientError.ERROR ("Conflict");
                }
                if (resp.code == 500) {
                    throw new ApiClientError.ERROR ("Server error");
                }
            } catch (HttpClientError error) {
                throw new ApiClientError.ERROR (error.message);
            }
        }

        /**
         * Returns info about a container.
         *
         * @param container The container to inspect.
         * @return A ContainerInspectInfo struct with detailed information.
         * @throws ApiClientError If an error occurs while inspecting the container.
         */
        public async ContainerInspectInfo inspect_container (Container container) throws ApiClientError {
            try {
                var container_info = ContainerInspectInfo ();
                var resp = yield this.http_client.r_get (@"/containers/$(container.id)/json");

                //
                if (resp.code == 404) {
                    throw new ApiClientError.ERROR ("No such container");
                }
                if (resp.code == 500) {
                    throw new ApiClientError.ERROR ("Server error");
                }

                //
                var json = yield resp.body_data_stream.read_line_utf8_async ();
                assert_nonnull (json);

                var root_node = parse_json (json);
                var root_object = root_node.get_object ();
                assert_nonnull (root_object);

                //
                container_info.name = root_object.get_string_member_with_default ("Name", _ ("Unknown"));

                //
                var state_object = root_object.get_object_member ("State");
                assert_nonnull (state_object);

                container_info.status = state_object.get_string_member_with_default ("Status", _ ("Unknown"));

                //
                var config_object = root_object.get_object_member ("Config");
                assert_nonnull (config_object);

                container_info.image = config_object.get_string_member_with_default ("Image", _ ("Unknown"));
                container_info.is_tty = config_object.get_boolean_member_with_default ("Tty", false);

                //
                var env_array = config_object.get_array_member ("Env");

                if (env_array != null && env_array.get_length () > 0) {
                    container_info.envs = new string[0];

                    foreach (var env_node in env_array.get_elements ()) {
                        container_info.envs += env_node.get_string () ?? _ ("Unknown");
                    }
                }

                //
                var host_config_object = root_object.get_object_member ("HostConfig");

                if (host_config_object != null) {
                    var binds_array = host_config_object.get_array_member ("Binds");

                    if (binds_array != null && binds_array.get_length () > 0) {
                        container_info.binds = new string[0];

                        foreach (var bind_node in binds_array.get_elements ()) {
                            container_info.binds += bind_node.get_string () ?? _ ("Unknown");
                        }
                    }
                }

                //
                var port_bindings_object = host_config_object.get_object_member ("PortBindings");

                if (port_bindings_object != null) {
                    port_bindings_object.foreach_member ((obj, key, port_binding_node) => {
                        var port_binding_array = port_binding_node.get_array ();

                        if (port_binding_array != null && port_binding_array.get_length () > 0) {
                            container_info.ports = new string[0];

                            foreach (var port_node in port_binding_array.get_elements ()) {
                                var port_object = port_node.get_object ();
                                assert_nonnull (port_object);

                                var ip = port_object.get_string_member_with_default ("HostIp", "");
                                var port = port_object.get_string_member_with_default ("HostPort", "-");

                                container_info.ports += key + (ip.length > 0 ? @"$ip:" : ":") + port;
                            }
                        }
                    });
                }

                return container_info;
            } catch (HttpClientError error) {
                throw new ApiClientError.ERROR (error.message);
            } catch (IOError error) {
                throw new ApiClientError.ERROR (error.message);
            }
        }

        /**
         * Gets the Docker version.
         *
         * @return Info about the version.
         * @throws ApiClientError If an error occurs while retrieving the version information.
         */
        public async DockerVersionInfo version () throws ApiClientError {
            try {
                var version = Docker.DockerVersionInfo ();
                var resp = yield this.http_client.r_get ("/version");

                //
                var json = yield resp.body_data_stream.read_line_utf8_async ();
                assert_nonnull (json);

                var root_node = parse_json (json);
                var root_object = root_node.get_object ();
                assert_nonnull (root_object);

                version.version = root_object.get_string_member_with_default ("Version", "-");
                version.api_version = root_object.get_string_member_with_default ("ApiVersion", "-");

                return version;
            } catch (HttpClientError error) {
                throw new ApiClientError.ERROR (error.message);
            } catch (IOError error) {
                throw new ApiClientError.ERROR (error.message);
            }
        }

        /**
         * Check if remote is accessible
         *
         * @throws ApiClientError If an error occurs while pinging the server.
         */
        public async void ping () throws ApiClientError {
            try {
                yield this.http_client.r_get ("/_ping");
            } catch (HttpClientError error) {
                if (error is HttpClientError.ERROR_NO_ENTRY) {
                    throw new ApiClientError.ERROR_NO_ENTRY (error.message);
                } else {
                    throw new ApiClientError.ERROR (error.message);
                }
            }
        }
    }
}
