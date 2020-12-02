# This script converts Markdown files from the Obsidian
# vault to a format that Franklin understands

md = joinpath(@__DIR__, "md")

start_page_name = "Home"
start_page_name_with_ext = start_page_name * ".md"

# Delete previously generated pages
standard_files = joinpath.(@__DIR__, ["404.md", "config.md"])
for file in filter(
        s -> endswith(s, ".md") && s ∉ standard_files,
        readdir(@__DIR__, join=true)
    )
    rm(file)
end

# Format the file name
format(name::AbstractString)::String = replace(lowercase(name), ' ' => '-')

# Create a hyperlink for the reference
function hyperlink(ref::AbstractString)::String
    ref = chop(ref, head=2, tail=2)
    if ref == start_page_name
        return "[$(start_page_name)](/)"
    else
        return "[$(ref)](/$(format(ref)))"
    end
end

# Color a single piece
macro color_ones(color::String, pieces::String...)
    return esc(
        quote
            if piece in $(pieces)
                snippet[index] = $("<span style=\"color:$(color)\">") * piece * "</span>"
            end
        end
    )
end

# Color a paired piece
macro color_doubles(flag_color::String, argument_color::String, flags::String...)
    return esc(
        quote
            if piece in $(flags)
                snippet[index] =
                $("<span style=\"color:$(flag_color)\">") * piece * "</span>"
                snippet[index+1] =
                $("<span style=\"color:$(argument_color)\">") * snippet[index+1] * "</span>"
            end
        end
    )
end

# Add custom syntax highlighting for FFMPEG snippets
function ffmpeg(snippet::AbstractString)::String

    # Define a snippet's class
    if count("\n", snippet) == 0
        class = ""
        snippet = split(chop(snippet, head=10, tail=3), ' ')
    else
        class = "class=\"ffmpeg\""
        snippet = split(chop(snippet, head=10, tail=4), ' ')
    end

    # Colors
    for (index, piece) in pairs(snippet)
        @color_ones "#721121" "ffmpeg"
        @color_ones "#885A89" "-y"
        @color_doubles "#885A89" "#48A9A6" "-i"
        @color_doubles(
            "#885A89",
            "#537A5A",
            "-b:a",
            "-c",
            "-c:s",
            "-c:d",
            "-c:v",
            "-c:a",
            "-crf",
            "-preset",
            "-pix_fmt",
            "-vf",
            "-maxrate",
            "-bufsize",
            "-movflags",
            "-ss",
            "-to",
        )
    end

    # Highlight the output file

    i = lastindex(snippet)
    if endswith(snippet[end], '\"')
        while !startswith(snippet[i], '\"')
            i -= 1
        end
    end

    for (index, piece) in pairs(snippet[end:-1:i])
        snippet[end-index+1] = "<span style=\"color:#48A9A6\">$(piece)</span>"
    end

    return """
    ~~~
    <code $(class)>$(join(snippet, ' '))</code>
    ~~~"""

end

# Change the formatting
for (root, dirs, files) in walkdir(md)
    for file in files

        name = chop(file, tail=3)
        path = joinpath(root, file)
        content = read(path, String)

        # Add the header
        content = """
        # $(name)

        """ * content

        # Replace hyperlinks with actual links
        content = replace(content, r"\[\[[\w+\s*]+\]\]" => hyperlink)

        # Add custom syntax highlighting for FFMPEG code snippets
        content = replace(content, r"```ffmpeg.*?```"s => ffmpeg)

        if file == start_page_name_with_ext
            # Add the metadata
            content = """
            @def title = "Pensieve"
            @def authors = "Pavel Sobolev"
            @def hascode = true

            """ * content

            open(joinpath(@__DIR__, "index.md"), "w") do io
                print(io, content)
            end
        else
            # Add the metadata
            content = """
            @def title = "$(name)"
            @def authors = "Pavel Sobolev"
            @def hascode = true

            """ * content

            open(joinpath(@__DIR__, format(file)), "w") do io
                print(io, content)
            end
        end

    end
end
