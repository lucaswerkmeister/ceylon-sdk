import ceylon.net.http.server.internal { DefaultServer }
import ceylon.net.http.server.websocket { WebSocketBaseEndpoint }
import ceylon.io { SocketAddress }

"A HTTP server."
by("Matej Lazar")
see(`function newServer`)
shared interface Server {
    
    "Start the server in the current thread."
    shared formal void start(
        SocketAddress socketAddress = SocketAddress("127.0.0.1", 8080), 
        Options serverOptions = Options());
    
    "Start the server in a new thread."
    shared formal void startInBackground(
        SocketAddress socketAddress = SocketAddress("127.0.0.1", 8080), 
        Options serverOptions = Options());
    
    "Stop the server."
    shared formal void stop();
    
    "Define endpoint by providing an 
     [[Endpoint]] or [[AsynchronousEndpoint]]."
    shared formal void addEndpoint(HttpEndpoint endpoint);
    
    "Define an endpoint by providing a
     [[WebSocketEndpoint]] or 
     [[WebSocketFragmentedEndpoint]]"
    shared formal void addWebSocketEndpoint(WebSocketBaseEndpoint endpoint);

    "Registers a status change listener.
     Listeners are called on status changes. 
     Statuses are: [[starting]], [[started]], 
     [[stopping]], [[stopped]]."
    shared formal void addListener(void listener(Status status));

}

"Create a new HTTP server."
shared Server newServer(
        {HttpEndpoint|WebSocketBaseEndpoint*} endpoints) 
    => DefaultServer(endpoints);
