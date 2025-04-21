using Utilities;
using Docker;
const string TEST_IMAGE = "hello-world";


public void test_get_request() {
    var client = new HttpClient();
    client.base_url = @"http://localhost/v$(Utilities.Constants.DOCKER_ENIGINE_API_VERSION)";
    client.unix_socket_path = Utilities.Constants.DOCKER_ENGINE_SOCKET_PATH;
    client.verbose = false;
    bool success = false;
    var loop = new MainLoop();

    client.r_get.begin("/_ping", (obj, res) => {
        try {
            var response = client.r_get.end(res);
            if (response.code == 200) {
                print("GET request successful: %s\n", response.body_data_stream.read_line());
                success = true;
            }
        } catch (Error e) {
            print(e.message);
        }
        loop.quit();
    });

    loop.run();

    assert(success);
}

public void test_delete_request() {
    create_test_container();

    var client = new HttpClient();
    client.base_url = @"http://localhost/v$(Utilities.Constants.DOCKER_ENIGINE_API_VERSION)";
    client.unix_socket_path = Utilities.Constants.DOCKER_ENGINE_SOCKET_PATH;
    client.verbose = false;

    bool success = false;
    var loop = new MainLoop();

    client.r_delete.begin("/containers/test_container?force=true", (obj, res) => {
        try {
            var response = client.r_delete.end(res);
            if (response.code == 204) {
                print("DELETE request successful\n");
                success = true;
            }
        } catch (Error e) {
            print(e.message);
        }
        loop.quit();
    });

    loop.run();

    assert(success);
}

public Docker.Container obtain_test_container() {
    var api_client = new ApiClient();
    Docker.Container? container = null;
    int index = 0;
    bool container_found = false;

    var loop = new MainLoop();

    api_client.list_containers.begin((obj, res) => {
        try {
            var containers = api_client.list_containers.end(res);
            if (containers != null) {
                while (index < containers.length && !container_found) {
                    if (containers[index].image == TEST_IMAGE) {
                        container_found = true;
                        container = containers[index];
                    }
                    index++;
                }
            } else {
                print("No containers found\n");
            }
        } catch (Error e) {
            print(e.message);
        }
        loop.quit();
    });

    loop.run();

    return container;
}

public void create_test_container() {
    Posix.system("docker run -d --name test_container hello-world");
}

public void remove_test_container() {
    Posix.system("docker rm -f test_container");
}

public int main(string[] args) {
    Test.init(ref args);

    Test.add_func("/httpclient/test_get_request", test_get_request);
    Test.add_func("/httpclient/test_delete_request", test_delete_request);

    return Test.run();
}