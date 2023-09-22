window.onload = () => {

    function mountLinks(elementLink) {
        if (elementLink.link) {
            var ul = document.getElementById("ul");

            var a = document.createElement("a");
            if (elementLink.path) {
                a.href = `${elementLink.protocol}://${elementLink.link}:${elementLink.port}/${elementLink.path}`;
            } else {
                a.href = `${elementLink.protocol}://${elementLink.link}:${elementLink.port}`;
            }
            a.target = "_blank";
            a.textContent = `${elementLink.name}`;

            var li = document.createElement("li");
            li.appendChild(a);

            ul.appendChild(li);
        }
    }

    const links = [
        {
            protocol: "http",
            link: window.location.hostname,
            name: "Adminer",
            port: 7080
        },
        {
            protocol: "http",
            link: window.location.hostname,
            name: "Mongo Express",
            port: 7081
        },
        {
            protocol: "http",
            link: window.location.hostname,
            name: "Redis PHP Admin",
            port: 7082
        },
        {
            protocol: "http",
            link: window.location.hostname,
            name: "Chatwoot",
            port: 7083
        },
        {
            protocol: "http",
            link: window.location.hostname,
            path: "manager",
            name: "Evolution API",
            port: 7084
        },
        {
            protocol: "http",
            link: window.location.hostname,
            name: "Typebot Builder",
            port: 7085
        },
        {
            protocol: "http",
            link: window.location.hostname,
            name: "Typebot Viewer",
            port: 7086
        },
        {
            protocol: "http",
            link: window.location.hostname,
            name: "N8N",
            port: 7087
        },
    ]

    links.forEach((link) => {
        mountLinks(link)
    })

}