# This script converts Markdown files from the Obsidian
# vault to a format that Franklin understands

md = joinpath(@__DIR__, "md")
pages = joinpath(@__DIR__, "pages")

start_page_name = "Start.md"

# Delete previously generated pages
rm(joinpath(@__DIR__, "index.md"), force=true)
rm(pages, force=true, recursive=true)

# Create a dict with pages and their paths

paths = Dict{String, String}()

for (root, dirs, files) in walkdir(md)
    for file in files
        name = replace(file, ".md" => "")
        path = joinpath(root, file)

        if file == start_page_name
            paths[name] = "[$(name)](/)"
        else
            paths[name] =
            "[$(name)](/pages/$(replace(lowercase(joinpath(relpath(root, md), name)), ' ' => '-')))"
        end
    end
end

# Change the formatting
for (root, dirs, files) in walkdir(md)
    for file in files

        path = joinpath(root, file)
        content = read(path, String)

        # Replace hyperlinks with actual links
        content = replace(
            content,
            r"\[\[[\w+\s*]+\]\]" => s -> paths[chop(s, head = 2, tail = 2)]
        )

        rel_path = relpath(root, md)
        out_path = joinpath(pages, replace(lowercase(rel_path), ' ' => '-'))

        mkpath(out_path)

        if file == start_page_name
            open(joinpath(@__DIR__, "index.md"), "w") do io
                print(io, content)
            end
        else
            open(joinpath(out_path, replace(lowercase(file), ' ' => '-')), "w") do io
                print(io, content)
            end
        end

    end
end
