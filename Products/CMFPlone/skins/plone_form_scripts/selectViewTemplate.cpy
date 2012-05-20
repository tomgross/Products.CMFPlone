## Script (Python) "selectViewTemplate"
##title=Helper method to select a view template
##bind container=container
##bind context=context
##bind namespace=
##bind script=script
##bind state=state
##bind subpath=traverse_subpath
##parameters=templateId

from Products.CMFPlone import PloneMessageFactory as _

REQUEST = context.REQUEST
response = REQUEST.response

if REQUEST.get('PUBLISHED') is script:
    # authenticate when it is the published object
    authenticator = context.restrictedTraverse('@@authenticator')
    if not authenticator.verify():
        context.plone_utils.addPortalMessage(_(u'Support for setting view via URL disabled.'), 'warning')
        view_select_url = context.absolute_url() + '/select_default_view'
        return response.redirect(view_select_url)

context.setLayout(templateId)

context.plone_utils.addPortalMessage(_(u'View changed.'))
return state
