using Docker;

public void test_pull() {
    bool pulled = false;
    var api_client = new ApiClient();

    // Create a main loop to wait for async operation
    var loop = new MainLoop();

    api_client.pull_image.begin("hello-world", (obj, res) => {
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

    // Will assert after the loop ran
    assert(pulled);
    print("after assert");
}


public int main (string[] args){
    Test.init (ref args);

    Test.add_func ("/test_pull", test_pull);


    return Test.run ();
}