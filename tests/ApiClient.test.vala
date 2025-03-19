using Docker;

public void test_pull(){
    bool pulled = false;
    var api_client = new ApiClient ();

    //  api_client.pull_image.begin("alpine/psql", (obj, res) => {
    //              try {
    //                  if(api_client.pull_image.end(res)){
    //                      pulled = true;
    //                  }
    //              } catch (Error e) {
    //                  pulled = false;
    //              }
    //          }); 
    assert (api_client != null);
}

public int main (string[] args){
    Test.init (ref args);

    Test.add_func ("/test_pull", test_pull);


    return Test.run ();
}