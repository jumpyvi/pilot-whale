using Docker;

const string TEST_IMAGE = "hello-world";

public void test_pull() {
    bool pulled = false;
    var api_client = new ApiClient();

    var loop = new MainLoop();

    api_client.pull_image.begin(TEST_IMAGE, (obj, res) => {
        try {
            if (api_client.pull_image.end(res)) {
                print("pulled\n");
                pulled = true;
            }
        } catch (Error e) {
            print(e.message);
            pulled = false;
        }
        loop.quit();
    });

    loop.run();

    assert(pulled);
}


public void test_find_by_name(){
    bool image_found = false;
    var api_client = new ApiClient();
    var index = 0;

    var loop = new MainLoop();

    api_client.find_remote_image_from_string.begin(TEST_IMAGE, (obj, res) => {
        try {
            var images = api_client.find_remote_image_from_string.end(res);
            if (images != null) {
                while (index < images.length && !image_found)
                {
                    if (images[index].name == TEST_IMAGE)
                    {
                        image_found = true;
                    }
                    index++;
                }
            } else {
                print("No images found\n");
            }
        } catch (Error e) {
            print(e.message);
        }
        loop.quit();
    });

    loop.run();

    assert(image_found);
}


public void test_list_containers(){
    bool container_found = false;
    var api_client = new ApiClient();
    var index = 0;

    create_test_container();

    var loop = new MainLoop();

    api_client.list_containers.begin((obj, res) => {
        try {
            var containers = api_client.list_containers.end(res);
            if (containers != null) {
                while (index < containers.length && !container_found)
                {
                    if (containers[index].image == TEST_IMAGE)
                    {
                        container_found = true;
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

    remove_test_container();
    assert(container_found);
}

public void test_restart_container() {
    var api_client = new ApiClient();
    create_test_container();
    Docker.Container container = obtain_test_container();
    bool restarted = false;

    var loop = new MainLoop();

    api_client.restart_container.begin(container, (obj, res) => {
        try {
            api_client.restart_container.end(res);
            print("Container restarted successfully\n");
            restarted = true;
        } catch (Error e) {
            print(e.message);
            restarted = false;
        }
        loop.quit();
    });

    loop.run();
    remove_test_container();
    assert(restarted);
}

public void test_pause_container() {
    var api_client = new ApiClient();
    create_test_container();
    Docker.Container container = obtain_test_container();
    bool paused = false;

    var loop = new MainLoop();

    api_client.pause_container.begin(container, (obj, res) => {
        try {
            api_client.pause_container.end(res);
            api_client.unpause_container.begin(container, (obj, res) => {
            try {
                api_client.unpause_container.end(res);
            } catch (Error e) {
                print(e.message);
            }
            });
            print("Container paused and unpaused successfully\n");
            paused = true;
        } catch (Error e) {
            print(e.message);
            paused = false;
        }
        loop.quit();
    });

    loop.run();
    remove_test_container();
    assert(paused);
}

public void test_get_info_container() {
    var api_client = new ApiClient();
    create_test_container();
    Docker.Container container = obtain_test_container();
    bool paused = false;

    var loop = new MainLoop();

    api_client.inspect_container.begin(container, (obj, res) => {
        try {
            api_client.inspect_container.end(res);
            print("Container paused and unpaused successfully\n");
            paused = true;
        } catch (Error e) {
            print(e.message);
            paused = false;
        }
        loop.quit();
    });

    loop.run();
    remove_test_container();
    assert(paused);
}


public void create_test_container(){
    Posix.system("docker run -d " + TEST_IMAGE);
}

public void remove_test_container(){
    Posix.system("docker rm -f $(docker ps -aq --filter ancestor=" + TEST_IMAGE + ")");
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

public int main (string[] args){
    Test.init (ref args);

    Test.add_func ("/test_pull", test_pull);
    Test.add_func ("/test_find_by_name", test_find_by_name);
    Test.add_func ("/test_list_containers", test_list_containers);
    Test.add_func ("/test_pause_container", test_pause_container);


    return Test.run ();
}