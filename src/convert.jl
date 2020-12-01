# This script converts Markdown files from the Obsidian
# vault to a format that Franklin understands

md = joinpath(@__DIR__, "md")

start_page_name = "Start"
start_page_name_with_ext = start_page_name * ".md"

# Delete previously generated pages
for file in filter(s -> s ∉ ["404.md", "config.md"], filter(endswith(".md"), readdir()))
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

# Change the formatting
for (root, dirs, files) in walkdir(md)
    for file in files

        path = joinpath(root, file)
        content = read(path, String)

        # Replace hyperlinks with actual links
        content = replace(content, r"\[\[[\w+\s*]+\]\]" => hyperlink)

        if file == start_page_name_with_ext
            open(joinpath(@__DIR__, "index.md"), "w") do io
                print(io, content)
            end
        else
            open(joinpath(@__DIR__, format(file)), "w") do io
                print(io, content)
            end
        end

    end
end
