<style scoped>


.hackgen {
    font-family: 'HackGen', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;
}
.hackgenNerd {
    font-family: 'HackGenNerd', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;
}

.applyCodeBlockFont(@font: "HackGenNerd") {
    pre[data-role=codeBlock] {
        font-family: @font, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;
    }
}


/* for markdown-preview */
body {
    counter-reset: chapter;
}

h1,
h2,
h3 {
    font-weight: normal;
}
h1 {
    counter-reset: sub-chapter;
    padding-bottom     : 0.3em;
    line-height        : 1.2;
    border-color       : black;
    border-bottom-width: 1px;
    border-bottom-style: solid;
}
h2 {
    counter-reset: section;
    position      : relative;
    padding-left  : 18px;
    padding-bottom: 0.3em;
    line-height   : 1.2;
}

h3 {
    display      : inline-block;
    position      : relative;
    margin-left  : 36px;
    border-bottom: solid 1px rgb(121, 190, 255);
    padding-bottom: 0.3em;
    line-height   : 1.2;
}

hr {
    border       : 0;
    height       : 2px;
    border-bottom: 2px solid;
}

h2 ~ :not(h1):not(h2):not(h3) {
    margin-left: 18px;
}
h3 ~ :not(h1):not(h2):not(h3) {
    margin-left: 36px;
}

.bold {
    font-weight: bold;
}

.italic {
    font-style: italic;
}


.right {
    text-align: right
}

.center {
    text-align: center
}

.left {
    text-align: left
}

table {
    width: 95%;
    max-width: 800px;
    word-break:break-word;
    border-collapse: collapse;
    tr {
        th {
            background-color: rgb(121, 190, 255);
            border: solid 1px black;
            text-align: center;
        }

        td {
            border: solid 1px black;
            text-align: left;
        }
    }
}


div.TOC ul {
counter-reset: section;
}



.markdown-preview {

    h1::before {
        counter-increment: chapter;
        content: counter(chapter) ". ";

    }
    h2::before {
        counter-increment: sub-chapter;
        content: counter(chapter) "." counter(sub-chapter) ". ";
        
    }
    h3::before {
        counter-increment: section;
        content: counter(chapter) "." counter(sub-chapter) "." counter(section) ". ";
    }

    div.TOC li {
        list-style: none;
    }
    div.TOC ul>li:before {
        counter-increment : section;
        content : counters(section, '.') '. ';
    }

}

</style>
