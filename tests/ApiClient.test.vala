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

    var loop = new MainLoop();

    api_client.find_remote_image_from_string.begin(TEST_IMAGE, (obj, res) => {
        try {
            var images = api_client.find_remote_image_from_string.end(res);
            if (images != null) {
                foreach (var image in images) {
                    if (image.name == TEST_IMAGE) {
                        image_found = true;
                        break;
                    }
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

public int main (string[] args){
    Test.init (ref args);

    Test.add_func ("/test_pull", test_pull);
    Test.add_func ("/test_find_by_name", test_find_by_name);


    return Test.run ();
}