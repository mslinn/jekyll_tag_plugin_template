# frozen_string_literal: true

require "jekyll_plugin_logger"
require_relative "jekyll_plugin_template/version"
require_relative "dumpers"

module JekyllPluginHooksName
  PLUGIN_NAME = "jekyll_plugin_hooks"
end

# This is the module-level description.
#
# The Jekyll log level defaults to :info, which means all the Jekyll.logger statements below will not generate output.
# You can control the log level when you start Jekyll.
# To set the log level to :debug, write an entery into _config.yml, like this:
# plugin_loggers:
#   JekyllPluginHooks: debug
#
# Jekyll::Hooks.register accepts two optional parameters:
#   :priority determines the load order for the hook plugins.
#     Valid values are: :lowest, :low, :normal, :high, and :highest.
#     Highest priority matches are applied first, lowest priority are applied last.
#     The defaul value is :normal
#   :safe is a boolean flag that informs Jekyll if this plugin may be safely executed in an environment
#     where arbitrary code execution is not allowed. This is used by GitHub Pages to determine which
#     core plugins may be used, and which are unsafe to run. If your plugin does not allow for arbitrary
#     code execution, set this to true. GitHub Pages still will not load your plugin, but if you submit it
#     for inclusion in core, it is best for this to be correct!
#     Default value is false.
module JekyllPluginHooks
  ########## :site hooks
  # These hooks influence the entire site

  # This hook is called just after the site initializes.
  # It is a good place to modify the configuration of the site.
  # This hook is triggered once per build / serve session.
  Jekyll::Hooks.register(:site, :after_init, :priority => :normal) do |site|
    @log_site.info { "Loaded #{JekyllPluginHooksName::PLUGIN_NAME} v#{JekyllPluginTemplate::VERSION} plugin." }
    @log_site.info { "Jekyll::Hooks.register(:site, :after_init) invoked." }
    Dumpers.dump_site(@log_site, "Jekyll::Hooks.register(:site, :after_init)", site)
  end

  # Called just after the site resets during regeneration
  # This is the first hook called, so this is the best place to define loggers
  Jekyll::Hooks.register(:site, :after_reset, :priority => :normal) do |site|
    @log_clean = PluginMetaLogger.instance.new_logger(:CleanHook,     PluginMetaLogger.instance.config)
    @log_docs  = PluginMetaLogger.instance.new_logger(:DocumentHooks, PluginMetaLogger.instance.config)
    @log_pages = PluginMetaLogger.instance.new_logger(:PageHooks,     PluginMetaLogger.instance.config)
    @log_posts = PluginMetaLogger.instance.new_logger(:PostHooks,     PluginMetaLogger.instance.config)
    @log_site  = PluginMetaLogger.instance.new_logger(:SiteHooks,     PluginMetaLogger.instance.config)
    @log_site.info { "Jekyll::Hooks.register(:site, :after_reset) invoked." }
    Dumpers.dump_site(@log_site, "Jekyll::Hooks.register(:site, :after_reset)", site)
  end

  # Called after all source files have been read and loaded from disk
  Jekyll::Hooks.register(:site, :post_read, :priority => :normal) do |site|
    @log_site.info { "Jekyll::Hooks.register(:site, :post_read) invoked." }
    Dumpers.dump_site(@log_site, "Jekyll::Hooks.register(:site, :post_read)", site)
  end

  # Called before rendering the whole site
  # This is the first hook in the site generation sequence where site['env'] has a value.
  # Consequently, this is the first hook that defines mode (production, development or test),
  # because it is derived from site['env']['JEKYLL_ENV']
  # @param payload [Hash] according to the docs, payload is a hash containing the variables available during rendering; the hash can be modified here.
  # However, the debugger shows payload has type Jekyll::UnifiedPayloadDrop
  Jekyll::Hooks.register(:site, :pre_render, :priority => :normal) do |site, payload|
    @log_site.info { "Jekyll::Hooks.register(:site, :pre_render) invoked." }
    @log_site.debug { dump(":site, :pre_render payload", payload) }
    Dumpers.dump_site(@log_site, "Jekyll::Hooks.register(:site, :pre_render)", site)
    Dumpers.dump_payload(@log_site, "Jekyll::Hooks.register(:site, :pre_render)", payload)
  end

  # Called after rendering the whole site, but before writing any files
  # @param payload [Hash] contains final values of variables after rendering the entire site (useful for sitemaps, feeds, etc).
  Jekyll::Hooks.register(:site, :post_render, :priority => :normal) do |site, payload|
    @log_site.info { "Jekyll::Hooks.register(:site, :post_render) invoked." }
    @log_site.debug { dump(":site, :post_render payload", payload) }
    Dumpers.dump_site(@log_site, "Jekyll::Hooks.register(:site, :post_render)", site)
    Dumpers.dump_payload(@log_site, "Jekyll::Hooks.register(:site, :post_render)", payload)
  end

  # Called after writing all of the rendered files to disk
  Jekyll::Hooks.register(:site, :post_write, :priority => :normal) do |site|
    @log_site.info { "Jekyll::Hooks.register(:site, :post_write) invoked." }
    Dumpers.dump_site(@log_site, "Jekyll::Hooks.register(:site, :post_write)", site)
  end

  ########## :pages hooks
  # These hooks provide fine-grained control over all pages in the site

  # Called whenever a page is initialized
  Jekyll::Hooks.register(:pages, :post_init, :priority => :normal) do |page|
    @log_pages.info { "Jekyll::Hooks.register(:pages, :post_init) invoked." }
    Dumpers.dump_page(@log_pages, "Jekyll::Hooks.register(:pages, :post_init)", page)
  end

  # Called just before rendering a page
  Jekyll::Hooks.register(:pages, :pre_render, :priority => :normal) do |page, payload|
    @log_pages.info { "Jekyll::Hooks.register(:pages, :pre_render) invoked." }
    Dumpers.dump_page(@log_pages, "Jekyll::Hooks.register(:pages, :pre_render)", page)
    @log_pages.debug { Dumpers.dump_payload(@log_pages, ":pages, :pre_render payload", payload) }
  end

  # Called after converting the page content, but before rendering the page layout
  Jekyll::Hooks.register(:pages, :post_convert, :priority => :normal) do |page|
    @log_pages.info { "Jekyll::Hooks.register(:pages, :post_convert) invoked." }
    Dumpers.dump_page(@log_pages, "Jekyll::Hooks.register(:pages, :post_convert)", page)
  end

  # Called after rendering a page, but before writing it to disk
  Jekyll::Hooks.register(:pages, :post_render, :priority => :normal) do |page|
    @log_pages.info { "Jekyll::Hooks.register(:pages, :post_render) invoked." }
    Dumpers.dump_page(@log_pages, "Jekyll::Hooks.register(:pages, :post_render)", page)
  end

  # Called after writing a page to disk
  Jekyll::Hooks.register(:pages, :post_write, :priority => :normal) do |page|
    @log_pages.info { "Jekyll::Hooks.register(:pages, :post_write) invoked." }
    Dumpers.dump_page(@log_pages, "Jekyll::Hooks.register(:pages, :post_write)", page)
  end

  ########## :documents hooks
  # These hooks fine-grained control over all documents in the site including posts and
  # documents in user-defined collections

  # Called whenever any document is initialized
  Jekyll::Hooks.register(:documents, :post_init, :priority => :normal) do |_document|
    @log_docs.info { "Jekyll::Hooks.register(:documents, :post_init) invoked." }
  end

  # Called just before rendering a document
  Jekyll::Hooks.register(:documents, :pre_render, :priority => :normal) do |_document, payload|
    @log_docs.info { "Jekyll::Hooks.register(:documents, :pre_render) invoked." }
    @log_docs.debug { Dumpers.dump_payload(@log_docs, ":documents, :pre_render payload", payload) }
  end

  # Called after converting the document content, but before rendering the document layout
  Jekyll::Hooks.register(:documents, :post_convert, :priority => :normal) do |_document|
    @log_docs.info { "Jekyll::Hooks.register(:documents, :post_convert) invoked." }
  end

  # Called after rendering a document, but before writing it to disk
  Jekyll::Hooks.register(:documents, :post_render, :priority => :normal) do |_document|
    @log_docs.info { "Jekyll::Hooks.register(:documents, :post_render) invoked." }
  end

  # Called after writing a document to disk
  Jekyll::Hooks.register(:documents, :post_write, :priority => :normal) do |_document|
    @log_docs.info { "Jekyll::Hooks.register(:documents, :post_write) invoked." }
  end

  ########## :posts hooks
  # These hooks provide fine-grained control over all posts in the site without affecting
  # documents in user-defined collections

  # Called whenever any post is initialized
  Jekyll::Hooks.register(:posts, :post_init, :priority => :normal) do |_post|
    @log_posts.info { "Jekyll::Hooks.register(:posts, :post_init) invoked." }
  end

  # Called just before rendering a post
  Jekyll::Hooks.register(:posts, :pre_render, :priority => :normal) do |_post, payload|
    @log_posts.info { "Jekyll::Hooks.register(:posts, :pre_render) invoked." }
    @log_posts.debug { Dumpers.dump_payload(@log_posts, ":posts, :pre_render payload", payload) }
  end

  # Called after converting the post content, but before rendering the post layout
  Jekyll::Hooks.register(:posts, :post_convert, :priority => :normal) do |_post|
    @log_posts.info { "Jekyll::Hooks.register(:posts, :post_convert) invoked." }
  end

  # Called after rendering a post, but before writing it to disk
  Jekyll::Hooks.register(:posts, :post_render, :priority => :normal) do |_post|
    @log_posts.info { "Jekyll::Hooks.register(:posts, :post_render) invoked." }
  end

  # Called after writing a post to disk
  Jekyll::Hooks.register(:posts, :post_write, :priority => :normal) do |_post|
    @log_posts.info { "Jekyll::Hooks.register(:posts, :post_write) invoked." }
  end

  ########## :clean hooks
  # These hooks provide fine-grained control on the list of obsolete files determined
  # to be deleted during the site's cleanup phase.

  # Called during the cleanup of a site's destination, before the site is built
  Jekyll::Hooks.register(:clean, :on_obsolete, :priority => :normal) do |file|
    @log_clean.info { "Jekyll::Hooks.register(:clean, :on_obsolete) invoked for #{file}." }
  end
end