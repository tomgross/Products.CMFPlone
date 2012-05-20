## Controller Python Script "setConstrainTypes"
##bind container=container
##bind context=context
##bind namespace=
##bind script=script
##bind state=state
##bind subpath=traverse_subpath
##title=Set the options for constraining addable types on a per-folder basis

from Products.CMFPlone import PloneMessageFactory as _
#plone_log=context.plone_log

if container.REQUEST.get('PUBLISHED') is script:
    # authenticate when it is the published object
    authenticator = context.restrictedTraverse('@@authenticator')
    if not authenticator.verify():
        context.plone_utils.addPortalMessage(_(u'CSRF protection activated.'), 'warning')
        factories = context.absolute_url() + '/folder_constraintypes_form'
        return state.set(status='factory',
            next_action='redirect_to:string:%s' % factories)

constrainTypesMode = context.REQUEST.get('constrainTypesMode', [])
currentPrefer = context.REQUEST.get('currentPrefer', [])
currentAllow = context.REQUEST.get('currentAllow', [])

#plone_log( "SET: currentAllow=%s, currentPrefer=%s" % ( currentAllow, currentPrefer ) )

# due to the logic in #6151 we actually need to do the following:
# - if a type is in "currentPrefer", then it's automatically
#   also an "locallyAllowedTypes" type.
# - types which are in "currentAllow" are to be removed from the
#   "immediatelyAddableTypes" list.
#
# That means:
# - users select types which they want to see in the menu using the
#   "immediatelyAddableTypes" list
# - if the user wants to see a certain type _only_ in the "more ..."
#   form, then they select it inside the "locallyAllowedTypes" list.

immediatelyAddableTypes = [ t for t in currentPrefer if not t in currentAllow ]
locallyAllowedTypes = [ t for t in currentPrefer ]

#plone_log( "SET: immediatelyAddableTypes=%s, locallyAllowedTypes=%s" % ( immediatelyAddableTypes, locallyAllowedTypes ) )

context.setConstrainTypesMode(constrainTypesMode)
context.setLocallyAllowedTypes(locallyAllowedTypes)
context.setImmediatelyAddableTypes(immediatelyAddableTypes)

context.plone_utils.addPortalMessage(_(u'Changes made.'))
return state
