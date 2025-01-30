I have a collection of [Docker](https://hub.docker.com/) services.
I want to be able to secure them with SSL [^rusty].

I have been using ChatGPT for a while now.
Let me tell you; it is a skill [^foo].
Not only do you need to know enough to use the right words, but you need to know enough to know when it is just making stuff up [^compile].
So after a couple rounds this is what I hit on based on my experience and its suggestion.

> Me: Can you help me with the steps to "Obtain a Let's Encrypt Certificate"?
>  ... {{We go around for a bit}} ...
> Me: Is there a docker container that automatically does SSL reverse proxy?
> ChatGPT ... {{suggestions that don't work}}[^self_fail] ... [Caddy](https://caddyserver.com/)

After a lot of back and forth [^missing_methods], I am left with this Demo.

# Steps [^requirements]

1. Open a VS Code shell[^vscode_shell]
   * Ctrl + Shift + ~
2. Setup the Docker Compose stack
   ```
   docker compose up -d
   ```
3. Open up a shell to a container with `curl`[^curl]
   ```
   docker exec -it caddyquickstart-testing-1 bash
   ```
3. Test connections and redirects under various scenaros.
   ```bash
   IP=$(ping -c 1 proxy | awk -F'[()]' '/PING/{print $2}') &&  echo $IP
   echo "$IP domain.local" | tee -a "/etc/hosts"
   echo "$IP admin.domain.local" | tee -a "/etc/hosts"
   curl $IP # (52) Empty reply ...
   curl http://$IP # (52) Empty reply ...
   curl -k https://$IP # (35) OpenSSL/3.0.15: error ...
   curl -i http://domain.local # HTTP/1.1 308 to https://domain.local/
   curl -ik https://domain.local # HTTP/2 200 <body>App 1</body>
   curl -i http://admin.domain.local # HTTP/1.1 308 to https://admin.domain.local/
   curl -ik https://admin.domain.local # HTTP/2 200 <body>App 2</body>
   exit
   ```
2. Cleanup the Docker Compose stack
   ```
   docker compose down
   docker rmi debian:caddy-testing
   ```

[^rusty]: I have done this a _lot_ in the past, but not since Pre-COVID, so all my skills are rusty.
[^foo]: I remember what it was like to have my "Google Foo" fail [^stacks].
I need to get skilled enough to properly frame my question so that I don't have a "AI Foo" fail. 
[^stacks] I also remember being chastised by my college'es librarian for using [Google Scholar](https://scholar.google.com/) because I can find everything I need in the [stacks](https://en.wikipedia.org/wiki/Library_stack).
Funny thing that, they don't even have stacks to search now. 
[^compile]: Just because it compiles, doesn't mean it does what you wanted.
[^self_fail]: Just because it exists, doesn't mean _you_ can implement it [^hydroponic].
[^hydroponic]: I know [hydroponic tomatoes](https://hydrobuilder.com/learn/hydroponic-tomatoes/) are a thing.
Mine always die.
My [reapers](https://en.wikipedia.org/wiki/Carolina_Reaper) always thrive.
[^requirements]: In case it was not obvious, you need [VS Code](https://code.visualstudio.com/), [Docker Desktop](https://www.docker.com/), and [Git](https://git-scm.com/downloads) to run the test.
[^vscode_shell]: I run on Windows, so my default shell in VS Code is PowerShell.
It _should not_ matter because the only commands I run directly in the VS Code are `docker ...`.
Anything you have that runs Docker should have it linked up in VS Code automaticaly[^ymmv].
[^ymmv]: [Your milage may vary](https://dictionary.cambridge.org/dictionary/english/ymmv)
[^missing_methods]: I am not recording all the [red/green/refactor](https://en.wikipedia.org/wiki/Test-driven_development) steps.
I want the result to be as small as posible so I can copy/paste it into a bigger projects.
I burnt a day with the AI.
If you want to recreate the project from [first principles](https://en.wikipedia.org/wiki/First_principle), feel free to do the same.
[^curl]: I wasted time on trying get around caching when I was moving from one backend service to two.
Straight-up use `cURL`.
